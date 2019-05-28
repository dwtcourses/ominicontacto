# -*- coding: utf-8 -*-
# Copyright (C) 2018 Freetech Solutions

# This file is part of OMniLeads

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses/.
#

from __future__ import unicode_literals

import json
from django import forms
from django.conf import settings
from django.forms.models import inlineformset_factory, BaseInlineFormSet, ModelChoiceField
from django.contrib.auth.forms import (
    UserChangeForm,
    UserCreationForm
)
from django.contrib.auth.password_validation import validate_password
from django.utils.translation import ugettext_lazy as _

from crispy_forms.helper import FormHelper
from crispy_forms.layout import Field, Layout, MultiField

from constance import config

from ominicontacto_app.models import (
    User, AgenteProfile, Queue, QueueMember, BaseDatosContacto, Grabacion,
    Campana, Contacto, CalificacionCliente, Grupo, Formulario, FieldFormulario, Pausa,
    RespuestaFormularioGestion, AgendaContacto, ActuacionVigente, Backlist, SitioExterno,
    SistemaExterno,
    ReglasIncidencia, UserApiCrm, SupervisorProfile, ArchivoDeAudio,
    NombreCalificacion, OpcionCalificacion, ParametrosCrm, AgenteEnSistemaExterno
)
from ominicontacto_app.services.campana_service import CampanaService
from ominicontacto_app.utiles import (convertir_ascii_string, validar_nombres_campanas,
                                      validar_solo_ascii_y_sin_espacios, elimina_tildes)
from configuracion_telefonia_app.models import DestinoEntrante

from utiles_globales import validar_extension_archivo_audio

TIEMPO_MINIMO_DESCONEXION = 2
EMPTY_CHOICE = ('', '---------')


class CustomUserChangeForm(UserChangeForm):

    class Meta(UserChangeForm.Meta):
        model = User
        fields = ('username', 'password', 'first_name', 'last_name', 'email', 'is_agente',
                  'is_supervisor')

    def clean_password(self):
        # Regardless of what the user provides, return the initial value.
        # This is done here, rather than on the field, because the
        # field does not have access to the initial value
        return self.initial["password"]


class CustomUserCreationForm(UserCreationForm):
    class Meta(UserCreationForm.Meta):
        model = User
        fields = (
            'username', 'first_name', 'last_name', 'email', 'is_agente',
            'is_supervisor', 'password1', 'password2')
        labels = {
            'is_agente': _('Es un agente'),
            'is_supervisor': _('Es un supervisor'),
        }
        error_messages = {
            'username': {'unique':
                         _('No se puede volver a utilizar dos veces el mismo nombre de usuario')}
        }

    def __init__(self, deshabilitar_agente=False, *args, **kwargs):
        super(CustomUserCreationForm, self).__init__(*args, **kwargs)
        self.fields['username'].widget.attrs['class'] = 'form-control'
        self.fields['first_name'].widget.attrs['class'] = 'form-control'
        self.fields['last_name'].widget.attrs['class'] = 'form-control'
        self.fields['email'].widget.attrs['class'] = 'form-control'
        self.fields['password1'].widget.attrs['class'] = 'form-control'
        self.fields['password2'].widget.attrs['class'] = 'form-control'

        if deshabilitar_agente:
            self.fields['is_agente'].widget.attrs['disabled'] = True

    def clean(self):
        super(CustomUserCreationForm, self).clean()
        is_agente = self.cleaned_data.get('is_agente', None)
        is_supervisor = self.cleaned_data.get('is_supervisor', None)
        if is_agente and is_supervisor:
            raise forms.ValidationError(
                _('Un usuario no puede ser Agente y Supervisor al mismo tiempo'))
        if not is_agente and not is_supervisor:
            raise forms.ValidationError(
                _('Un usuario debe ser Agente o Supervisor'))
        return self.cleaned_data


class UserChangeForm(forms.ModelForm):
    """A form for updating users. Includes all the fields on
    the user, but replaces the password field with admin's
    password hash display field.
    """

    password1 = forms.CharField(max_length=20,
                                required=False,
                                # will be overwritten by __init__()
                                help_text=_('Ingrese la nueva contraseña '
                                            '(sólo si desea cambiarla)'),
                                # will be overwritten by __init__()
                                widget=forms.PasswordInput(),
                                label=_('Contraseña'))

    password2 = forms.CharField(
        max_length=20,
        required=False,  # will be overwritten by __init__()
        # will be overwritten by __init__()
        help_text=_('Ingrese la nueva contraseña (sólo si desea cambiarla)'),
        widget=forms.PasswordInput(),
        label=_('Contraseña (otra vez)'))

    def clean(self):
        cleaned_data = super(UserChangeForm, self).clean()
        password1 = cleaned_data.get('password1')
        password2 = cleaned_data.get('password2')
        if password1 != '':
            validate_password(password1)
        if password1 != password2:
            raise forms.ValidationError(_('Las contraseñas no coinciden'))
        return self.cleaned_data

    class Meta:
        model = User
        fields = ('username', 'first_name', 'last_name', 'email', 'password1', 'password2')
        error_messages = {
            'username': {'unique':
                         _('No se puede volver a utilizar dos veces el mismo nombre de usuario')}
        }


class AgenteProfileForm(forms.ModelForm):
    """A form for updating users. Includes all the fields on
    the user, but replaces the password field with admin's
    password hash display field.
    """

    class Meta:
        model = AgenteProfile
        fields = ('modulos', 'grupo')

    def __init__(self, modulos_queryset, grupos_queryset, *args, **kwargs):
        super(AgenteProfileForm, self).__init__(*args, **kwargs)
        self.fields['modulos'].widget.attrs['class'] = 'form-control'
        self.fields['modulos'].queryset = modulos_queryset
        self.fields['grupo'].widget.attrs['class'] = 'form-control'
        self.fields['grupo'].queryset = grupos_queryset


class QueueEntranteForm(forms.ModelForm):
    """
    El form de cola para las colas
    """
    tipo_destino = forms.ChoiceField(
        widget=forms.Select(attrs={'class': 'form-control', 'id': 'tipo_destino'}), required=False
    )

    def __init__(self, audios_choices, *args, **kwargs):
        super(QueueEntranteForm, self).__init__(*args, **kwargs)
        self.fields['timeout'].required = True
        self.fields['retry'].required = True
        self.fields['announce_frequency'].required = False
        self.fields['audios'].queryset = ArchivoDeAudio.objects.all()
        self.fields['audio_de_ingreso'].queryset = ArchivoDeAudio.objects.all()
        tipo_destino_choices = [EMPTY_CHOICE]
        tipo_destino_choices.extend(DestinoEntrante.TIPOS_DESTINOS)
        self.fields['tipo_destino'].choices = tipo_destino_choices
        instance = getattr(self, 'instance', None)
        if instance.pk is not None and instance.destino:
            tipo = instance.destino.tipo
            self.initial['tipo_destino'] = tipo
            destinos_qs = DestinoEntrante.get_destinos_por_tipo(tipo)
            destino_entrante_choices = [EMPTY_CHOICE] + [(dest_entr.id, dest_entr.__unicode__())
                                                         for dest_entr in destinos_qs]
            self.fields['destino'].choices = destino_entrante_choices
        else:
            self.fields['destino'].choices = ()
        if not instance.pk:
            self.initial['wrapuptime'] = 2

    class Meta:
        model = Queue
        fields = ('name', 'timeout', 'retry', 'maxlen', 'wrapuptime', 'servicelevel',
                  'strategy', 'weight', 'wait', 'auto_grabacion', 'campana',
                  'audios', 'announce_frequency', 'audio_de_ingreso', 'campana',
                  'tipo_destino', 'destino')

        help_texts = {
            'timeout': _('En segundos'),
            'retry': _('En segundos'),
            'announce_frequency': _('En segundos'),
            'wait': _('En segundos'),
            'wrapuptime': _('En segundos'),
        }
        widgets = {
            'name': forms.HiddenInput(),
            'campana': forms.HiddenInput(),
            'timeout': forms.TextInput(attrs={'class': 'form-control'}),
            'retry': forms.TextInput(attrs={'class': 'form-control'}),
            'maxlen': forms.TextInput(attrs={'class': 'form-control'}),
            "wrapuptime": forms.TextInput(attrs={'class': 'form-control'}),
            'servicelevel': forms.TextInput(attrs={'class': 'form-control'}),
            'strategy': forms.Select(attrs={'class': 'form-control'}),
            'weight': forms.TextInput(attrs={'class': 'form-control'}),
            'wait': forms.TextInput(attrs={'class': 'form-control'}),
            'audios': forms.Select(attrs={'class': 'form-control'}),
            'announce_frequency': forms.TextInput(attrs={'class': 'form-control'}),
            'audio_de_ingreso': forms.Select(attrs={'class': 'form-control'}),
            'tipo_destino': forms.Select(attrs={'class': 'form-control'}),
            'destino': forms.Select(attrs={'class': 'form-control', 'id': 'destino'}),
        }

    def clean_maxlen(self):
        maxlen = self.cleaned_data.get('maxlen')
        if not maxlen > 0:
            raise forms.ValidationError('Cantidad Max de llamadas debe ser'
                                        ' mayor a cero')
        return maxlen

    def clean_announce_frequency(self):
        audio = self.cleaned_data.get('audios', None)
        frequency = self.cleaned_data.get('announce_frequency', None)
        if audio and not (frequency > 0):
            raise forms.ValidationError(
                _('Debe definir una frecuencia para el Anuncio Periódico'))
        return frequency

    def clean_destino(self):
        tipo_destino = self.cleaned_data.get('tipo_destino', None)
        destino = self.cleaned_data.get('destino', None)
        if tipo_destino and not destino:
            raise forms.ValidationError(
                _('Debe seleccionar un destino'))
        return destino


class QueueMemberForm(forms.ModelForm):
    """
    El form de miembro de una cola
    """

    def __init__(self, members, *args, **kwargs):
        super(QueueMemberForm, self).__init__(*args, **kwargs)

        self.fields['member'].queryset = members
        self.initial['penalty'] = 0

    class Meta:
        model = QueueMember
        fields = ('member', 'penalty')


class BaseDatosContactoForm(forms.ModelForm):

    class Meta:
        model = BaseDatosContacto
        fields = ('nombre', 'archivo_importacion')
        widgets = {
            'nombre': forms.TextInput(attrs={'class': 'form-control'}),
            'archivo_importacion': forms.FileInput(attrs={'class': 'form-control'}),
        }


class DefineColumnaTelefonoForm(forms.Form):

    def __init__(self, cantidad_columnas=0, *args, **kwargs):
        super(DefineColumnaTelefonoForm, self).__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.form_tag = False

        COLUMNAS_TELEFONO = []
        for columna in range(int(cantidad_columnas)):
            COLUMNAS_TELEFONO.append((columna, 'Columna{0}'.format(columna)))

        self.fields['telefono'] = forms.ChoiceField(choices=COLUMNAS_TELEFONO,
                                                    widget=forms.RadioSelect(
                                                        attrs={'class':
                                                               'telefono'}))
        self.helper.layout = Layout(MultiField('telefono'))


class DefineDatosExtrasForm(forms.Form):

    def __init__(self, cantidad_columnas=0, *args, **kwargs):
        super(DefineDatosExtrasForm, self).__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.form_tag = False

        crispy_fields = []
        for columna in range(int(cantidad_columnas)):
            value = forms.ChoiceField(choices=BaseDatosContacto.DATOS_EXTRAS,
                                      required=False, label="",
                                      widget=forms.Select(
                                          attrs={'class': 'datos-extras'}))
            self.fields['datos-extras-{0}'.format(columna)] = value

            crispy_fields.append(Field('datos-extras-{0}'.format(columna)))
        self.helper.layout = Layout(crispy_fields)


class DefineNombreColumnaForm(forms.Form):

    def __init__(self, cantidad_columnas=0, *args, **kwargs):
        super(DefineNombreColumnaForm, self).__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.form_tag = False

        crispy_fields = []
        for columna in range(int(cantidad_columnas)):
            self.fields['nombre-columna-{0}'.format(columna)] = \
                forms.CharField(label="", initial='Columna{0}'.format(columna),
                                error_messages={'required': ''},
                                widget=forms.TextInput(attrs={'class':
                                                       'nombre-columna'}))
            crispy_fields.append(Field('nombre-columna-{0}'.format(columna)))
        self.helper.layout = Layout(crispy_fields)


class PrimerLineaEncabezadoForm(forms.Form):
    es_encabezado = forms.BooleanField(label="Primer fila es encabezado.",
                                       required=False)

    def __init__(self, *args, **kwargs):
        super(PrimerLineaEncabezadoForm, self).__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.form_tag = False
        self.helper.layout = Layout(Field('es_encabezado'))


class CamposDeBaseDeDatosForm(forms.Form):
    """ Formulario para identificar campos especiales de la base de datos """
    campos_telefonicos = forms.MultipleChoiceField(
        required=True,
        label=_('Campos de teléfono'),
        widget=forms.CheckboxSelectMultiple())
    id_externo = forms.ChoiceField(required=False,
                                   widget=forms.Select(attrs={'class': 'form-control'}))

    def __init__(self, nombres_campos, *args, **kwargs):
        super(CamposDeBaseDeDatosForm, self).__init__(*args, **kwargs)
        self.nombres_campos = nombres_campos
        self.fields['campos_telefonicos'].choices = tuple([(x, x) for x in nombres_campos])
        id_externo_choices = [EMPTY_CHOICE]
        id_externo_choices.extend(tuple([(x, x) for x in nombres_campos]))
        self.fields['id_externo'].choices = id_externo_choices

    def clean(self):
        campos_telefonicos = self.cleaned_data.get('campos_telefonicos', [])
        if len(campos_telefonicos) > 0:
            id_externo = self.cleaned_data.get('id_externo')
            if id_externo in campos_telefonicos:
                msg = _('No se puede elegir un campo telefónico como id_externo')
                raise forms.ValidationError(msg)
        return super(CamposDeBaseDeDatosForm, self).clean()

    @property
    def columnas_de_telefonos(self):
        # Guardo los indices de los nombres de las columnas que tienen telefonos
        seleccionados = self.cleaned_data.get('campos_telefonicos', [])
        return [i for i, x in enumerate(self.nombres_campos) if x in seleccionados]

    @property
    def columna_id_externo(self):
        # Devuelvo el indice del nombre de la columnas del id externo
        seleccionado = self.cleaned_data.get('id_externo', '')
        if seleccionado in self.nombres_campos:
            return self.nombres_campos.index(seleccionado)
        return None


class BusquedaContactoForm(forms.Form):
    buscar = forms.CharField(
        required=False,
        widget=forms.TextInput(
            attrs={'class': 'form-control', 'placeholder': _('texto a buscar')}
        )
    )


class GrabacionBusquedaForm(forms.Form):
    """
    El form para la busqueda de grabaciones
    """
    fecha = forms.CharField(required=False,
                            widget=forms.TextInput(attrs={'class': 'form-control'}),
                            label=_('Fecha'))
    tipo_llamada_choice = list(Grabacion.TYPE_LLAMADA_CHOICES)
    tipo_llamada_choice.insert(0, EMPTY_CHOICE)
    tipo_llamada = forms.ChoiceField(required=False,
                                     choices=tipo_llamada_choice, label=_('Tipo de llamada'))
    tel_cliente = forms.CharField(required=False)
    agente = forms.ModelChoiceField(queryset=AgenteProfile.objects.filter(is_inactive=False),
                                    required=False, label=_('Agente'))
    campana = forms.ChoiceField(required=False, choices=(), label=_('Campaña'))
    pagina = forms.CharField(required=False, widget=forms.HiddenInput(), label=_('Página'))
    marcadas = forms.BooleanField(required=False, label=_('Marcadas'))
    duracion = forms.IntegerField(required=False, min_value=0, initial=0,
                                  label=_('Duración mínima'),
                                  widget=forms.NumberInput(attrs={'class': 'form-control'}))
    gestion = forms.BooleanField(required=False, label=_('Calificada como gestión'))

    def __init__(self, campana_choice, *args, **kwargs):
        super(GrabacionBusquedaForm, self).__init__(*args, **kwargs)
        campana_choice.insert(0, EMPTY_CHOICE)
        self.fields['campana'].choices = campana_choice
        self.fields['duracion'].help_text = _('En segundos')


class CampanaMixinForm(object):
    def __init__(self, *args, **kwargs):
        super(CampanaMixinForm, self).__init__(*args, **kwargs)
        self.fields['bd_contacto'].required = not self.initial.get('es_template', False)
        if self.fields.get('bd_contacto', False):
            self.fields['bd_contacto'].queryset = BaseDatosContacto.objects.obtener_definidas()

    def requiere_bd_contacto(self):
        raise NotImplementedError

    def clean(self):
        bd_contacto_field = self.fields.get('bd_contacto', False)
        sistema_externo = self.cleaned_data.get('sistema_externo', False)
        bd_contacto = self.cleaned_data.get('bd_contacto', False)
        if sistema_externo and bd_contacto and not bd_contacto.get_metadata().columna_id_externo:
            message = _("Una campaña asignada a un sistema externo debe usar una"
                        " base de contactos con campo de id externo definido")
            raise forms.ValidationError(message, code='invalid')
        if (bd_contacto_field and not bd_contacto_field.queryset.filter and
                self.requiere_bd_contacto()):
            message = _("Debe cargar una base de datos antes de comenzar a "
                        "configurar una campana")
            self.add_error('bd_contacto', message)
            raise forms.ValidationError(message, code='invalid')
        if self.cleaned_data.get('tipo_interaccion') is Campana.SITIO_EXTERNO and \
                not self.cleaned_data.get('sitio_externo'):
            message = _("Debe seleccionar un sitio externo")
            self.add_error('sitio_externo', message)
            raise forms.ValidationError(message, code='invalid')
        return super(CampanaMixinForm, self).clean()

    def clean_nombre(self):
        nombre = self.cleaned_data['nombre']
        validar_nombres_campanas(nombre)
        return nombre

    def clean_tipo_interaccion(self):
        tipo_interaccion = self.cleaned_data.get('tipo_interaccion', None)
        if self.instance and self.instance.pk:
            return self.instance.tipo_interaccion
        return tipo_interaccion

    def clean_id_externo(self):
        sistema_externo = self.cleaned_data.get('sistema_externo', None)
        id_externo = self.cleaned_data.get('id_externo', '')
        if sistema_externo and id_externo:
            # Validar que no este repetido
            campana_con_id_externo = sistema_externo.campanas.filter(id_externo=id_externo)
            if self.instance.id:
                campana_con_id_externo = campana_con_id_externo.exclude(id=self.instance.id)
            if campana_con_id_externo.exists():
                msg = _("Ya existe una Campaña con ese id externo para el Sistema Externo elegido")
                raise forms.ValidationError(msg)
        if id_externo and not sistema_externo:
            msg = _("No puede indicar un id externo sin elegir un Sistema Externo")
            raise forms.ValidationError(msg)
        return id_externo


class CampanaForm(CampanaMixinForm, forms.ModelForm):

    def __init__(self, *args, **kwargs):
        super(CampanaForm, self).__init__(*args, **kwargs)
        instance = getattr(self, 'instance', None)
        if instance.pk is None:
            self.fields['bd_contacto'].required = False
        else:
            self.fields['nombre'].disabled = True
            self.fields['bd_contacto'].required = True
            self.fields['tipo_interaccion'].disabled = True
            self.fields['tipo_interaccion'].required = False

    def requiere_bd_contacto(self):
        return False

    def clean_bd_contacto(self):
        bd_contacto = self.cleaned_data.get('bd_contacto')
        bd_contacto_field = 'bd_contacto'
        if self.instance.pk and bd_contacto_field in self.changed_data:
            campana_service = CampanaService()
            error = campana_service.validar_modificacion_bd_contacto(
                self.instance, bd_contacto)
            if error:
                raise forms.ValidationError(
                    _("Los nombres de las columnas de la nueva base de datos no coinciden"
                      " con la anterior"),
                    code='invalid')
        return bd_contacto

    class Meta:
        model = Campana
        fields = ('nombre', 'bd_contacto', 'sistema_externo', 'id_externo',
                  'sitio_externo', 'tipo_interaccion', 'objetivo', 'mostrar_nombre')
        labels = {
            'bd_contacto': 'Base de Datos de Contactos',
        }

        widgets = {
            'nombre': forms.TextInput(attrs={'class': 'form-control'}),
            'bd_contacto': forms.Select(attrs={'class': 'form-control'}),
            'sistema_externo': forms.Select(attrs={'class': 'form-control'}),
            'id_externo': forms.TextInput(attrs={'class': 'form-control'}),
            'sitio_externo': forms.Select(attrs={'class': 'form-control'}),
            'objetivo': forms.NumberInput(attrs={'class': 'form-control'}),
            'tipo_interaccion': forms.RadioSelect(),
        }


class OpcionCalificacionForm(forms.ModelForm):
    class Meta:
        model = OpcionCalificacion
        fields = ('tipo', 'nombre', 'formulario', 'campana')

        widgets = {
            'nombre': forms.Select(),
            'usada_en_calificacion': forms.HiddenInput(),
        }

    def __init__(self, *args, **kwargs):
        nombres_calificaciones = kwargs.pop('nombres_calificaciones')
        con_formulario = kwargs.pop('con_formulario')
        super(OpcionCalificacionForm, self).__init__(*args, **kwargs)
        instance = getattr(self, 'instance', None)
        if instance and instance.pk:
            # al modificar, en caso de que el valor del campo 'nombre' no esté entre las
            # calificaciones creadas se agrega
            choices = set(nombres_calificaciones + ((instance.nombre, instance.nombre),))
        else:
            # al crear se muestra en primer lugar una opción vacía
            choices = (EMPTY_CHOICE,) + nombres_calificaciones
        self.fields['nombre'] = forms.ChoiceField(choices=choices)

        if instance and instance.pk and instance.no_editable():
            self.fields['nombre'].disabled = True
            self.fields['tipo'].disabled = True
            self.fields['formulario'].disabled = True
        else:
            self.fields['tipo'].choices = OpcionCalificacion.FORMULARIO_CHOICES_NO_AGENDA

        if not con_formulario:
            self.fields.pop('formulario')

    def clean_nombre(self):
        instance = getattr(self, 'instance', None)
        if instance.pk is None and instance.nombre == settings.CALIFICACION_REAGENDA:
            raise forms.ValidationError(
                _("El nombre de la opción de calificación '{0}' está reservado para uso interno"
                  " del sistema, por favor use otro".format(instance.nombre)))
        if instance and instance.pk and instance.no_editable():
            return instance.nombre
        else:
            return self.cleaned_data['nombre']

    def clean_tipo(self):
        instance = getattr(self, 'instance', None)
        if instance and instance.pk and instance.no_editable():
            return instance.tipo
        else:
            return self.cleaned_data['tipo']

    def clean_formulario(self):
        instance = getattr(self, 'instance', None)
        if instance and instance.pk and instance.no_editable():
            return instance.formulario
        else:
            tipo = self.cleaned_data.get('tipo', None)
            if tipo == OpcionCalificacion.GESTION:
                # TODO: Solo si se eligio tipo_interaccion Formulario!!!
                formulario = self.cleaned_data.get('formulario', None)
                if not formulario:
                    raise forms.ValidationError(_("Debe elegir un formulario para la gestión."))
                return formulario
            return None


class OpcionCalificacionBaseFormset(BaseInlineFormSet):

    def _construct_form(self, index, **kwargs):
        # adicionamos dinámicamente las nombres de calificaciones existentes en el sistema
        # para que el usuario pueda escoger de ellas al crear las opciones de calificación
        nombres_calificaciones_qs = NombreCalificacion.objects.usuarios().values_list(
            'nombre', flat=True)
        kwargs['nombres_calificaciones'] = tuple((nombre, nombre)
                                                 for nombre in nombres_calificaciones_qs)
        return super(OpcionCalificacionBaseFormset, self)._construct_form(index, **kwargs)

    def _validar_numero_opciones_calificacion(self, save_candidates_forms):

        # en el caso de la modificación vamos a tener un form más que en la creación por la
        # creación automática de la calificación reservada de Agenda
        MIN_NUM_FORMS = int(self.instance.pk is not None) + 1
        if MIN_NUM_FORMS == 1:
            msg = _("Debe ingresar al menos {0} opción de calificación".format(MIN_NUM_FORMS))
        else:
            # MIN_NUM_FORMS == 2
            msg = _("Debe ingresar al menos {0} opciones de calificación".format(MIN_NUM_FORMS))

        if len(save_candidates_forms) < MIN_NUM_FORMS:
            raise forms.ValidationError(msg, code='invalid')

    def clean(self):
        """
        Realiza los validaciones relacionadas con la semántica de las opciones de calificación
        """
        if any(self.errors):
            return
        nombres = []
        tipos_gestion_cont = 0
        deleted_forms = self.deleted_forms
        save_candidates_forms = set(self.forms) - set(deleted_forms)

        self._validar_numero_opciones_calificacion(save_candidates_forms)

        for form in save_candidates_forms:
            nombre = form.cleaned_data.get('nombre', None)
            tipo = form.cleaned_data.get('tipo', None)
            if nombre is None or tipo is None:
                raise forms.ValidationError(_("Rellene los campos en blanco"), code='invalid')
            if nombre in nombres:
                raise forms.ValidationError(
                    _("Los nombres de las opciones de calificación deben ser distintos"),
                    code="invalid")
            if tipo == OpcionCalificacion.GESTION:
                tipos_gestion_cont += 1
            nombres.append(nombre)
        if tipos_gestion_cont == 0:
            raise forms.ValidationError(
                _("Debe escoger una opción de calificación de tipo gestión por campaña"),
                code='invalid')

    def save(self):
        """
        Inserta la una opción de calificación interna del sistema para agendar contactos
        """
        campana = self.instance
        if campana.estado != Campana.ESTADO_TEMPLATE_ACTIVO:
            campana.gestionar_opcion_calificacion_agenda()
        super(OpcionCalificacionBaseFormset, self).save()


OpcionCalificacionFormSet = inlineformset_factory(
    Campana, OpcionCalificacion, form=OpcionCalificacionForm,
    formset=OpcionCalificacionBaseFormset, extra=0, min_num=1)


class OpcionCalificacionModelChoiceField(ModelChoiceField):
    def label_from_instance(self, obj):
        return obj.nombre


class CalificacionClienteForm(forms.ModelForm):
    """
    Formulario para la creacion de Calificaciones de Clientes
    """

    opcion_calificacion = OpcionCalificacionModelChoiceField(
        OpcionCalificacion.objects.all(), empty_label='---------', label=_('Calificación'))

    def __init__(self, campana, *args, **kwargs):
        historico_calificaciones = kwargs.pop('historico_calificaciones')
        super(CalificacionClienteForm, self).__init__(*args, **kwargs)
        self.campana = campana
        self.historico_calificaciones = historico_calificaciones
        self.fields['opcion_calificacion'].queryset = campana.opciones_calificacion.all()

    class Meta:
        model = CalificacionCliente
        fields = ('opcion_calificacion', 'observaciones')
        widgets = {
            'opcion_calificacion': forms.Select(attrs={'class': 'form-control'}),
        }
        labels = {
            'observaciones': _('Observaciones'),
        }


class GrupoAgenteForm(forms.Form):
    grupo = forms.ChoiceField(choices=())

    def __init__(self, *args, **kwargs):
        super(GrupoAgenteForm, self).__init__(*args, **kwargs)
        grupo_choice = [(grupo.id, grupo.nombre)
                        for grupo in Grupo.objects.all()]
        self.fields['grupo'].choices = grupo_choice


class AgendaBusquedaForm(forms.Form):
    """
    El busquedad form poara agente
    """
    fecha = forms.CharField(required=False,
                            widget=forms.TextInput(
                                attrs={'class': 'form-control'}))


class ReporteForm(forms.Form):
    """
    El form para reporte con fecha
    """
    fecha = forms.CharField(widget=forms.TextInput(
        attrs={'class': 'form-control'}))


class FormularioForm(forms.ModelForm):

    class Meta:
        model = Formulario
        fields = ('nombre', 'descripcion')
        widgets = {
            "nombre": forms.TextInput(attrs={'class': 'form-control'}),
            "descripcion": forms.Textarea(attrs={'class': 'form-control'}),
        }


class FieldFormularioForm(forms.ModelForm):
    list_values = forms.MultipleChoiceField(widget=forms.SelectMultiple(
        attrs={'class': 'form-control', 'style': 'width:100%;',
               'disabled': 'disabled'}), required=False)
    value_item = forms.CharField(widget=forms.TextInput(
        attrs={'class': 'form-control', 'disabled': 'disabled',
               'placeholder': 'agregar item a la lista'}), required=False)

    class Meta:
        model = FieldFormulario
        fields = ('formulario', 'nombre_campo', 'tipo', 'values_select',
                  'is_required')
        widgets = {
            'formulario': forms.HiddenInput(),
            'tipo': forms.Select(attrs={'class': 'form-control'}),
            "nombre_campo": forms.TextInput(attrs={'class': 'form-control'}),
            'values_select': forms.HiddenInput(),
        }

    def clean_nombre_campo(self):
        formulario = self.cleaned_data.get('formulario')
        nombre_campo = self.cleaned_data.get('nombre_campo')
        nombre_campo = elimina_tildes(nombre_campo)
        if formulario.campos.filter(nombre_campo=nombre_campo).exists():
            raise forms.ValidationError(_('No se puede crear un campo ya existente'))
        return nombre_campo

    def clean_values_select(self):
        tipo = self.cleaned_data.get('tipo')
        if not tipo == FieldFormulario.TIPO_LISTA:
            return None
        values_select = self.cleaned_data.get('values_select')
        if values_select == '':
            raise forms.ValidationError(_('La lista no puede estar vacía'))
        try:
            lista_values_select = json.loads(values_select)
        except ValueError:
            raise forms.ValidationError(_('Formato inválido'))
        if type(lista_values_select) is not list:
            raise forms.ValidationError(_('Formato inválido'))
        if len(lista_values_select) == 0:
            raise forms.ValidationError(_('La lista no puede estar vacía'))
        return values_select


class OrdenCamposForm(forms.Form):
    sentido_orden = forms.CharField()

    def __init__(self, *args, **kwargs):
        super(OrdenCamposForm, self).__init__(*args, **kwargs)
        self.fields['sentido_orden'].widget = forms.HiddenInput()


class FormularioCRMForm(forms.Form):

    def __init__(self, campos, *args, **kwargs):
        super(FormularioCRMForm, self).__init__(*args, **kwargs)

        for campo in campos:
            if campo.tipo is FieldFormulario.TIPO_TEXTO:
                self.fields[campo.nombre_campo] = forms.CharField(
                    label=campo.nombre_campo, widget=forms.TextInput(
                        attrs={'class': 'form-control'}),
                    required=campo.is_required)
            elif campo.tipo is FieldFormulario.TIPO_FECHA:
                self.fields[campo.nombre_campo] = forms.CharField(
                    label=campo.nombre_campo, widget=forms.TextInput(
                        attrs={'class': 'class-fecha form-control'}),
                    required=campo.is_required)
            elif campo.tipo is FieldFormulario.TIPO_LISTA:
                choices = [(option, option)
                           for option in json.loads(campo.values_select)]
                self.fields[campo.nombre_campo] = forms.ChoiceField(
                    choices=choices,
                    label=campo.nombre_campo, widget=forms.Select(
                        attrs={'class': 'form-control'}),
                    required=campo.is_required)
            elif campo.tipo is FieldFormulario.TIPO_TEXTO_AREA:
                self.fields[campo.nombre_campo] = forms.CharField(
                    label=campo.nombre_campo, widget=forms.Textarea(
                        attrs={'class': 'form-control'}),
                    required=campo.is_required)


class SincronizaDialerForm(forms.Form):
    evitar_duplicados = forms.BooleanField(required=False)
    evitar_sin_telefono = forms.BooleanField(required=False)
    prefijo_discador = forms.CharField(required=False, widget=forms.TextInput(
        attrs={'class': 'class-fecha form-control'}))


class FormularioNuevoContacto(forms.ModelForm):

    class Meta:
        model = Contacto
        fields = ('telefono', 'id_externo')
        widgets = {
            "telefono": forms.TextInput(attrs={'class': 'form-control'}),
            "id_externo": forms.TextInput(attrs={'class': 'form-control'}),
        }

    def __init__(self, base_datos=None, *args, **kwargs):
        if 'instance' in kwargs and kwargs['instance'] is not None:
            contacto = kwargs['instance']
            self.base_datos = contacto.bd_contacto
            bd_metadata = contacto.bd_contacto.get_metadata()
            datos = json.loads(contacto.datos)
            for nombre, dato in zip(bd_metadata.nombres_de_columnas_de_datos, datos):
                kwargs['initial'].update({self.get_nombre_input(nombre): dato})
        else:
            self.base_datos = base_datos
            bd_metadata = base_datos.get_metadata()

        super(FormularioNuevoContacto, self).__init__(*args, **kwargs)
        nombre_campo_telefono = bd_metadata.nombre_campo_telefono
        nombre_campo_id_externo = bd_metadata.nombre_campo_id_externo
        for campo in bd_metadata.nombres_de_columnas:
            if campo == nombre_campo_telefono:
                nombre_campo = convertir_ascii_string(campo)
                self.fields['telefono'].label = nombre_campo
            elif campo == nombre_campo_id_externo:
                nombre_campo = convertir_ascii_string(campo)
                self.fields['id_externo'].label = nombre_campo
                self.fields['id_externo'].required = False
            else:
                nombre_campo = self.get_nombre_input(campo)
                self.fields[nombre_campo] = forms.CharField(
                    required=False,
                    label=campo, widget=forms.TextInput(
                        attrs={'class': 'form-control'}))

        if nombre_campo_id_externo is None:
            self.fields.pop('id_externo')

        self.bd_metadata = bd_metadata

    @classmethod
    def get_nombre_input(cls, nombre_campo):
        """
        Además del Encode modifico el nombre del input correspondiente a un campo de datos
        de nombre "telefono" para que no se solape con el input 'telefono' correspondiente al campo
        del modelo Contacto
        """
        nombre_input = convertir_ascii_string(nombre_campo)
        if nombre_input == 'telefono':
            # NOTA: Se asume que ninguna base de datos vendra con un campo con el nombre devuelto
            return "input_telefono_en_datos_OML"
        return nombre_input

    def get_datos_json(self):
        """ Devuelve datos en json listos para guardar en el modelo Contacto """
        datos = []
        for nombre in self.bd_metadata.nombres_de_columnas_de_datos:
            campo = self.cleaned_data.get(self.get_nombre_input(nombre))
            datos.append(campo)
        return json.dumps(datos)

    def es_campo_telefonico(self, nombre_input):
        """ Devuelve si el nombre del input corresponde a una columna con telefono o no """
        for i in self.bd_metadata.columnas_con_telefono:
            nombre_campo = self.bd_metadata.nombres_de_columnas[i]
            if nombre_input == self.get_nombre_input(nombre_campo):
                return True
        return False

    def clean_id_externo(self):
        id_externo = self.cleaned_data.get('id_externo')
        # Si el campo no esta vacío
        if not id_externo == '' and id_externo is not None:
            # Validar que no este repetido
            contacto_con_id_externo = self.base_datos.contactos.filter(id_externo=id_externo)
            if self.instance.id:
                contacto_con_id_externo = contacto_con_id_externo.exclude(id=self.instance.id)
            if contacto_con_id_externo.exists():
                msg = _("Ya existe un contacto con ese id externo en la base de datos")
                raise forms.ValidationError(msg)
        return id_externo

    def clean(self):
        if not self.instance.id:
            self.instance.bd_contacto = self.base_datos
        return super(FormularioNuevoContacto, self).clean()


class FormularioCampanaContacto(forms.Form):
    campana = forms.ChoiceField(
        choices=(), widget=forms.Select(attrs={'class': 'form-control'}))

    def __init__(self, campana_choice, *args, **kwargs):
        super(FormularioCampanaContacto, self).__init__(*args, **kwargs)
        self.fields['campana'].choices = campana_choice


class UpdateBaseDatosForm(forms.ModelForm):
    evitar_duplicados = forms.BooleanField(required=False)
    evitar_sin_telefono = forms.BooleanField(required=False)
    prefijo_discador = forms.CharField(required=False)
    telefonos = forms.MultipleChoiceField(
        required=False,
        widget=forms.CheckboxSelectMultiple,
        choices=(),
    )

    def __init__(self, tts_choices, *args, **kwargs):
        super(UpdateBaseDatosForm, self).__init__(*args, **kwargs)
        self.fields['telefonos'].choices = tts_choices

    class Meta:
        model = Campana
        fields = ('bd_contacto',)
        labels = {
            'bd_contacto': 'Base de Datos de Contactos',
        }
        widgets = {
            'bd_contacto': forms.Select(attrs={'class': 'form-control'}),
        }


class PausaForm(forms.ModelForm):

    class Meta:
        model = Pausa
        fields = ('nombre', 'tipo')
        widgets = {
            'tipo': forms.Select(attrs={'class': 'form-control'}),
        }

    def clean_nombre(self):
        nombre = self.cleaned_data['nombre']
        validar_nombres_campanas(nombre)
        return nombre


FormularioCalificacionFormSet = inlineformset_factory(
    Contacto, CalificacionCliente, form=CalificacionClienteForm,
    can_delete=False, extra=1, max_num=1)


class RespuestaFormularioGestionForm(forms.ModelForm):

    def __init__(self, campos, *args, **kwargs):
        super(RespuestaFormularioGestionForm, self).__init__(*args, **kwargs)

        for campo in campos:
            if campo.tipo is FieldFormulario.TIPO_TEXTO:
                self.fields[campo.nombre_campo] = forms.CharField(
                    label=campo.nombre_campo, widget=forms.TextInput(
                        attrs={'class': 'form-control'}),
                    required=campo.is_required)
            elif campo.tipo is FieldFormulario.TIPO_FECHA:
                self.fields[campo.nombre_campo] = forms.CharField(
                    label=campo.nombre_campo, widget=forms.TextInput(
                        attrs={'class': 'class-fecha form-control'}),
                    required=campo.is_required)
            elif campo.tipo is FieldFormulario.TIPO_LISTA:
                choices = [(option, option)
                           for option in json.loads(campo.values_select)]
                self.fields[campo.nombre_campo] = forms.ChoiceField(
                    choices=choices,
                    label=campo.nombre_campo, widget=forms.Select(
                        attrs={'class': 'form-control'}),
                    required=campo.is_required)
            elif campo.tipo is FieldFormulario.TIPO_TEXTO_AREA:
                self.fields[campo.nombre_campo] = forms.CharField(
                    label=campo.nombre_campo, widget=forms.Textarea(
                        attrs={'class': 'form-control'}),
                    required=campo.is_required)

    class Meta:
        model = RespuestaFormularioGestion
        fields = ('calificacion', )
        widgets = {
            'calificacion': forms.HiddenInput(),
        }


class AgendaContactoForm(forms.ModelForm):

    class Meta:
        model = AgendaContacto
        fields = ('contacto', 'agente', 'campana', 'tipo_agenda', 'fecha', 'hora', 'observaciones')
        widgets = {
            'contacto': forms.HiddenInput(),
            'agente': forms.HiddenInput(),
            'campana': forms.HiddenInput(),
            'tipo_agenda': forms.Select(attrs={'class': 'form-control'}),
            "observaciones": forms.Textarea(attrs={'class': 'form-control'}),
            "fecha": forms.TextInput(attrs={'class': 'form-control'}),
            "hora": forms.TextInput(attrs={'class': 'form-control'}),
        }

    def __init__(self, *args, **kwargs):
        super(AgendaContactoForm, self).__init__(*args, **kwargs)
        if not kwargs['initial']['campana'].type == Campana.TYPE_DIALER:
            self.fields['tipo_agenda'].choices = [(AgendaContacto.TYPE_PERSONAL, 'PERSONAL')]

    def clean_tipo_agenda(self):
        campana = self.cleaned_data.get('campana', None)
        if not campana and campana.type == Campana.TYPE_DIALER:
            return AgendaContacto.TYPE_PERSONAL
        return self.cleaned_data['tipo_agenda']


class CampanaDialerForm(CampanaMixinForm, forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super(CampanaDialerForm, self).__init__(*args, **kwargs)

        es_template = self.initial.get('es_template', False)

        self.fields['fecha_inicio'].help_text = 'Ejemplo: 10/04/2014'
        self.fields['fecha_fin'].help_text = 'Ejemplo: 20/04/2014'
        self.fields['fecha_inicio'].required = not es_template
        self.fields['fecha_fin'].required = not es_template

        if self.instance.pk:
            self.fields['nombre'].disabled = not es_template
            self.fields['bd_contacto'].disabled = True
            self.fields['tipo_interaccion'].required = False

    def requiere_bd_contacto(self):
        return True

    def clean_bd_contacto(self):
        instance = getattr(self, 'instance', None)
        if instance and instance.pk:
            return instance.bd_contacto
        else:
            return self.cleaned_data['bd_contacto']

    class Meta:
        model = Campana
        fields = ('nombre', 'fecha_inicio', 'fecha_fin',
                  'bd_contacto', 'sitio_externo', 'sistema_externo', 'id_externo',
                  'tipo_interaccion', 'objetivo', 'mostrar_nombre')
        labels = {
            'bd_contacto': 'Base de Datos de Contactos',
        }

        widgets = {
            'bd_contacto': forms.Select(attrs={'class': 'form-control'}),
            'sistema_externo': forms.Select(attrs={'class': 'form-control'}),
            'id_externo': forms.TextInput(attrs={'class': 'form-control'}),
            'sitio_externo': forms.Select(attrs={'class': 'form-control'}),
            'tipo_interaccion': forms.RadioSelect(),
            'objetivo': forms.NumberInput(attrs={'class': 'form-control'}),
        }


class ActuacionVigenteForm(forms.ModelForm):
    """
    El form de miembro de una cola
    """

    def clean(self):
        domingo = self.cleaned_data.get('domingo')
        lunes = self.cleaned_data.get('lunes')
        martes = self.cleaned_data.get('martes')
        miercoles = self.cleaned_data.get('miercoles')
        jueves = self.cleaned_data.get('jueves')
        viernes = self.cleaned_data.get('viernes')
        sabado = self.cleaned_data.get('sabado')
        if domingo == lunes == martes == miercoles == jueves == viernes == sabado is False:
            raise forms.ValidationError(_('Debe seleccionar algun día'))

        return self.cleaned_data

    class Meta:
        model = ActuacionVigente
        fields = ('domingo', 'lunes', 'martes', 'miercoles', 'jueves',
                  'viernes', 'sabado', 'hora_desde', 'hora_hasta')
        widgets = {
            'dia_semanal': forms.Select(attrs={'class': 'form-control'}),
            "hora_desde": forms.TextInput(attrs={'class': 'form-control'}),
            "hora_hasta": forms.TextInput(attrs={'class': 'form-control'}),
        }


class BacklistForm(forms.ModelForm):

    class Meta:
        model = Backlist
        fields = ('nombre', 'archivo_importacion')
        widgets = {
            'nombre': forms.TextInput(attrs={'class': 'form-control'}),
            'archivo_importacion': forms.FileInput(attrs={'class': 'form-control'}),
        }


class SistemaExternoForm(forms.ModelForm):

    class Meta:
        model = SistemaExterno
        fields = ('nombre', )


class SitioExternoForm(forms.ModelForm):

    class Meta:
        model = SitioExterno
        fields = ('nombre', 'url', 'disparador', 'metodo', 'formato', 'objetivo')

        widgets = {
            "nombre": forms.TextInput(attrs={'class': 'form-control'}),
            "url": forms.TextInput(attrs={'class': 'form-control'}),
            "disparador": forms.Select(attrs={'class': 'form-control'}),
            "metodo": forms.Select(attrs={'class': 'form-control'}),
            "formato": forms.Select(attrs={'class': 'form-control'}),
            "objetivo": forms.Select(attrs={'class': 'form-control'}),
        }

    def clean_objetivo(self):
        disparador = self.cleaned_data.get('disparador')
        objetivo = self.cleaned_data.get('objetivo')
        formato = self.cleaned_data.get('formato')
        if disparador == SitioExterno.SERVER:
            if objetivo:
                msg = _('Si el disparador es el servidor, no puede haber un objetivo.')
                raise forms.ValidationError(msg)
        elif formato == SitioExterno.JSON:
            if objetivo:
                msg = _('Si el formato JSON, no puede haber un objetivo.')
                raise forms.ValidationError(msg)
        elif objetivo == '':
            raise forms.ValidationError(_('Debe indicar un objetivo.'))
        return objetivo

    def clean_formato(self):
        metodo = self.cleaned_data.get('metodo')
        formato = self.cleaned_data.get('formato')
        if metodo == SitioExterno.GET:
            if formato:
                msg = _('Si el método es GET, no debe indicarse formato.')
                raise forms.ValidationError(msg)
        elif formato == '':
            msg = _('Si el método es POST, debe seleccionar un formato válido.')
            raise forms.ValidationError(msg)
        return formato


class ReglasIncidenciaForm(forms.ModelForm):

    class Meta:
        model = ReglasIncidencia
        fields = ('estado', 'intento_max', 'reintentar_tarde')

        widgets = {
            'estado': forms.Select(attrs={'class': 'form-control'}),
            "intento_max": forms.TextInput(attrs={'class': 'form-control'}),
            "reintentar_tarde": forms.TextInput(attrs={'class': 'form-control'}),
        }

    def save(self, commit=True):
        regla = super(ReglasIncidenciaForm, self).save(commit=False)
        if regla.estado == ReglasIncidencia.TERMINATED:
            regla.estado_personalizado = ReglasIncidencia.ESTADO_PERSONALIZADO_CONTESTADOR
        if commit:
            regla.save()
        return regla


class ReglasIncidenciaBaseFomset(BaseInlineFormSet):

    def clean(self):
        """
        Realiza la  validación de que no existan reglas de incidencia de un mismo tipo repetidas
        """
        if any(self.errors):
            return
        estados_reglas = []
        for form in self.forms:
            estado = form.cleaned_data.get('estado')
            if estado in estados_reglas:
                raise forms.ValidationError(
                    _("Los nombres de los estados de las reglas deben ser distintos"))
            estados_reglas.append(estado)


ReglasIncidenciaFormSet = inlineformset_factory(
    Campana, ReglasIncidencia, form=ReglasIncidenciaForm, formset=ReglasIncidenciaBaseFomset,
    extra=1, min_num=0)


class QueueDialerForm(forms.ModelForm):
    """
    El form de cola para las llamadas
    """
    tipo_destino = forms.ChoiceField(
        widget=forms.Select(attrs={'class': 'form-control', 'id': 'tipo_destino'}), required=False
    )

    class Meta:
        model = Queue
        fields = ('name', 'maxlen', 'wrapuptime', 'servicelevel', 'strategy', 'weight',
                  'wait', 'auto_grabacion', 'campana', 'detectar_contestadores',
                  'audio_para_contestadores', 'initial_predictive_model', 'initial_boost_factor',
                  'dial_timeout', 'tipo_destino', 'destino')

        widgets = {
            'campana': forms.HiddenInput(),
            'name': forms.HiddenInput(),
            "maxlen": forms.TextInput(attrs={'class': 'form-control'}),
            "wrapuptime": forms.TextInput(attrs={'class': 'form-control'}),
            "servicelevel": forms.TextInput(attrs={'class': 'form-control'}),
            'strategy': forms.Select(attrs={'class': 'form-control'}),
            "weight": forms.TextInput(attrs={'class': 'form-control'}),
            "wait": forms.TextInput(attrs={'class': 'form-control'}),
            "audio_para_contestadores": forms.Select(attrs={'class': 'form-control'}),
            "initial_boost_factor": forms.NumberInput(attrs={'class': 'form-control'}),
            "dial_timeout": forms.NumberInput(attrs={'class': 'form-control'}),
            'tipo_destino': forms.Select(attrs={'class': 'form-control'}),
            'destino': forms.Select(attrs={'class': 'form-control', 'id': 'destino'}),
        }

        help_texts = {
            'dial_timeout': _(""" Es recomendable que este valor sea menor al dial timeout
            definido en la ruta saliente. En segundos"""),
            'wrapuptime': _('En segundos'),
            'wait': _('En segundos'),
        }

    def clean(self):
        initial_boost_factor = self.cleaned_data.get('initial_boost_factor')
        if initial_boost_factor and initial_boost_factor < 1.0:
            raise forms.ValidationError('El factor boost inicial no debe ser'
                                        ' menor a 1.0')

        initial_predictive_model = self.cleaned_data.get('initial_predictive_model')
        if initial_predictive_model and not initial_boost_factor:
            raise forms.ValidationError('El factor boost inicial no deber ser'
                                        ' none si la predicitvidad está activa')

        dial_timeout = self.cleaned_data.get('dial_timeout')
        if dial_timeout < 10 or dial_timeout > 90:
            raise forms.ValidationError(_('El valor de dial timeout deberá estar comprendido entre'
                                        ' 10 y 90 segundos'))

        return self.cleaned_data

    def clean_destino(self):
        tipo_destino = self.cleaned_data.get('tipo_destino', None)
        destino = self.cleaned_data.get('destino', None)
        if tipo_destino and not destino:
            raise forms.ValidationError(
                _('Debe seleccionar un destino'))
        return destino

    def __init__(self, *args, **kwargs):
        super(QueueDialerForm, self).__init__(*args, **kwargs)
        self.fields['audio_para_contestadores'].queryset = ArchivoDeAudio.objects.all()
        tipo_destino_choices = [EMPTY_CHOICE]
        tipo_destino_choices.extend(DestinoEntrante.TIPOS_DESTINOS)
        self.fields['tipo_destino'].choices = tipo_destino_choices
        instance = getattr(self, 'instance', None)
        if instance.pk is not None and instance.destino:
            tipo = instance.destino.tipo
            self.initial['tipo_destino'] = tipo
            destinos_qs = DestinoEntrante.get_destinos_por_tipo(tipo)
            destino_entrante_choices = [EMPTY_CHOICE] + [(dest_entr.id, dest_entr.__unicode__())
                                                         for dest_entr in destinos_qs]
            self.fields['destino'].choices = destino_entrante_choices
        else:
            self.fields['destino'].choices = ()

        if not instance.pk:
            self.initial['wrapuptime'] = 2


class UserApiCrmForm(forms.ModelForm):

    class Meta:
        model = UserApiCrm
        fields = ('usuario', 'password')

        widgets = {
            "usuario": forms.TextInput(attrs={'class': 'form-control'}),
            "password": forms.PasswordInput(attrs={'class': 'form-control'}),
        }

    def clean_usuario(self):
        usuario = self.cleaned_data['usuario']
        if ' ' in usuario:
            raise forms.ValidationError(_('El usuario no puede contener espacios'))
        return usuario


ROL_CHOICES = ((SupervisorProfile.ROL_GERENTE, _('Supervisor Gerente')),
               (SupervisorProfile.ROL_ADMINISTRADOR, _('Administrador')),
               (SupervisorProfile.ROL_CLIENTE, _('Cliente')))


class SupervisorProfileForm(forms.ModelForm):
    rol = forms.ChoiceField(choices=ROL_CHOICES, label=_('Rol del usuario'),
                            initial=SupervisorProfile.ROL_GERENTE,
                            widget=forms.Select(attrs={'class': 'form-control'}))

    class Meta:
        model = SupervisorProfile
        fields = ('rol', )

    def __init__(self, rol, *args, **kwargs):
        super(SupervisorProfileForm, self).__init__(*args, **kwargs)
        self.fields['rol'].initial = rol


class CampanaSupervisorUpdateForm(forms.ModelForm):

    def __init__(self, *args, **kwargs):
        supervisors_choices = kwargs.pop('supervisors_choices', [])
        supervisors_required = kwargs.pop('supervisors_required', False)
        super(CampanaSupervisorUpdateForm, self).__init__(*args, **kwargs)
        self.fields['supervisors'].choices = supervisors_choices
        self.fields['supervisors'].required = supervisors_required

    class Meta:
        model = Campana
        fields = ('supervisors',)


class CampanaManualForm(CampanaMixinForm, forms.ModelForm):
    auto_grabacion = forms.BooleanField(required=False)
    detectar_contestadores = forms.BooleanField(required=False)

    def __init__(self, *args, **kwargs):
        super(CampanaManualForm, self).__init__(*args, **kwargs)
        instance = getattr(self, 'instance', None)
        if instance.pk is None:
            self.fields['bd_contacto'].required = False
        else:
            self.fields['nombre'].disabled = True
            self.fields['bd_contacto'].required = True

    class Meta:
        model = Campana
        fields = ('nombre', 'bd_contacto', 'sistema_externo', 'id_externo',
                  'sitio_externo', 'tipo_interaccion', 'objetivo')

        widgets = {
            'sistema_externo': forms.Select(attrs={'class': 'form-control'}),
            'id_externo': forms.TextInput(attrs={'class': 'form-control'}),
            'sitio_externo': forms.Select(attrs={'class': 'form-control'}),
            'tipo_interaccion': forms.RadioSelect(),
            'objetivo': forms.NumberInput(attrs={'class': 'form-control'}),
            'bd_contacto': forms.Select(attrs={'class': 'form-control'}),
        }

    def requiere_bd_contacto(self):
        return False


class CampanaPreviewForm(CampanaMixinForm, forms.ModelForm):
    auto_grabacion = forms.BooleanField(required=False)

    def __init__(self, *args, **kwargs):
        super(CampanaPreviewForm, self).__init__(*args, **kwargs)
        instance = getattr(self, 'instance', None)
        if instance and instance.pk and not self.initial.get('es_template', False):
            self.fields['nombre'].disabled = True
            self.fields['bd_contacto'].disabled = True
            self.fields['tiempo_desconexion'].disabled = True
            self.fields['tipo_interaccion'].disabled = True
            self.fields['tipo_interaccion'].required = False

    class Meta:
        model = Campana
        fields = ('nombre', 'sistema_externo', 'id_externo',
                  'sitio_externo', 'tipo_interaccion', 'objetivo', 'bd_contacto',
                  'tiempo_desconexion')

        widgets = {
            'bd_contacto': forms.Select(attrs={'class': 'form-control'}),
            'sistema_externo': forms.Select(attrs={'class': 'form-control'}),
            'id_externo': forms.TextInput(attrs={'class': 'form-control'}),
            'sitio_externo': forms.Select(attrs={'class': 'form-control'}),
            'tipo_interaccion': forms.RadioSelect(),
            'objetivo': forms.NumberInput(attrs={'class': 'form-control'}),
            'tiempo_desconexion': forms.NumberInput(attrs={'class': 'form-control'}),
        }

    def requiere_bd_contacto(self):
        return True

    def clean_tiempo_desconexion(self):
        tiempo_desconexion = self.cleaned_data['tiempo_desconexion']
        if tiempo_desconexion < TIEMPO_MINIMO_DESCONEXION:
            msg = 'Debe ingresar un minimo de {0} minutos'.format(TIEMPO_MINIMO_DESCONEXION)
            raise forms.ValidationError(msg)
        return tiempo_desconexion


class CalificacionForm(forms.ModelForm):
    class Meta:
        model = NombreCalificacion
        fields = ('nombre',)

    def clean_nombre(self):
        nombre = self.cleaned_data['nombre']
        if nombre == settings.CALIFICACION_REAGENDA:
            message = _('Esta calificación está reservada para el sistema')
            raise forms.ValidationError(message, code='invalid')
        return nombre


class ArchivoDeAudioForm(forms.ModelForm):

    class Meta:
        model = ArchivoDeAudio
        fields = ('descripcion', 'audio_original')
        widgets = {
            "descripcion": forms.TextInput(attrs={'class': 'form-control'}),
            "audio_original": forms.FileInput(attrs={'class': 'form-control'}),
        }
        help_texts = {
            'audio_original': _("Seleccione el archivo de audio que desea para "
                                "la Campaña. Si ya existe uno y guarda otro, el audio será "
                                "reemplazado."),
        }

    def __init__(self, *args, **kwargs):
        super(ArchivoDeAudioForm, self).__init__(*args, **kwargs)
        self.fields['audio_original'].required = True

    def clean(self):
        cleaned_data = super(ArchivoDeAudioForm, self).clean()
        audio_original = cleaned_data.get('audio_original', False)
        if audio_original:
            validar_extension_archivo_audio(audio_original)
        return cleaned_data


class EscogerCampanaForm(forms.Form):
    campana = forms.ChoiceField(
        label=_("Escoja una campaña"), choices=(),
        widget=forms.Select(attrs={'class': 'form-control'}))

    def __init__(self, *args, **kwargs):
        campanas = kwargs.pop('campanas', None)
        super(EscogerCampanaForm, self).__init__(*args, **kwargs)
        choices = [(pk, nombre) for pk, nombre in campanas]
        self.fields['campana'].choices = choices


class GrupoForm(forms.ModelForm):

    class Meta:
        model = Grupo
        fields = ('nombre', 'auto_unpause', 'auto_attend_ics', 'auto_attend_inbound',
                  'auto_attend_dialer')
        widgets = {
            'auto_unpause': forms.NumberInput(attrs={'class': 'form-control'}),
        }
        help_texts = {
            'auto_unpause': _('En segundos'),
        }

    def __init__(self, *args, **kwargs):
        super(GrupoForm, self).__init__(*args, **kwargs)
        self.fields['auto_unpause'].required = False


class ParametrosCrmForm(forms.ModelForm):

    def __init__(self, columnas_bd, *args, **kwargs):
        super(ParametrosCrmForm, self).__init__(*args, **kwargs)
        self.columnas_bd = columnas_bd
        self.columnas_bd_keys = [x[0] for x in columnas_bd]

    class Meta:
        model = ParametrosCrm
        fields = ('tipo', 'valor', 'nombre')

        widgets = {
            'tipo': forms.Select(attrs={'class': 'form-control'}),
            'valor': forms.TextInput(attrs={'class': 'form-control', 'placeholder': _(u'Valor')}),
            'nombre': forms.TextInput(attrs={'class': 'form-control', 'placeholder': _(u'Nombre')}),
        }

    def clean_valor(self):
        tipo = self.cleaned_data.get('tipo')
        valor = self.cleaned_data.get('valor')
        if tipo == ParametrosCrm.DATO_CONTACTO and valor not in self.columnas_bd_keys:
            raise forms.ValidationError(
                _('El valor debe corresponder a un campo de la base de datos de contactos'))
        if tipo == ParametrosCrm.DATO_CAMPANA and valor not in ParametrosCrm.OPCIONES_CAMPANA_KEYS:
            raise forms.ValidationError(
                _('El valor debe corresponder a un campo válido de la campaña'))
        if tipo == ParametrosCrm.DATO_LLAMADA and valor not in ParametrosCrm.OPCIONES_LLAMADA_KEYS:
            raise forms.ValidationError(
                _('El valor debe corresponder a un dato válido de la llamada'))
        if tipo == ParametrosCrm.CUSTOM:
            validar_solo_ascii_y_sin_espacios(valor)
        return valor

    def clean_nombre(self):
        nombre = self.cleaned_data.get('nombre', '')
        if not nombre:
            raise forms.ValidationError(_('Debe definir un nombre para el parámetro'))
        validar_solo_ascii_y_sin_espacios(nombre)
        return nombre


class QueueMemberBaseFomset(BaseInlineFormSet):

    def clean(self):
        """Realiza la  validación de que no existan miembros de cola repetidas para una misma
        cola de campaña
        """
        if any(self.errors):
            return
        members = []
        for form in self.forms:
            member = form.cleaned_data.get('member')
            if member in members:
                raise forms.ValidationError(
                    _("Los agentes deben ser distintos"))
            members.append(member)


ParametrosCrmFormSet = inlineformset_factory(
    Campana, ParametrosCrm, form=ParametrosCrmForm, extra=1, can_delete=True)

QueueMemberFormset = inlineformset_factory(
    Queue, QueueMember, formset=QueueMemberBaseFomset, form=QueueMemberForm, extra=1,
    can_delete=True, min_num=0)

AgenteEnSistemaExternoFormset = inlineformset_factory(
    SistemaExterno, AgenteEnSistemaExterno, fields=('agente', 'id_externo_agente'),
    extra=1, can_delete=True, min_num=0)


class RegistroForm(forms.Form):
    nombre = forms.CharField(label=_("Inserte su nombre o empresa"),
                             widget=forms.TextInput(attrs={'class': 'form-control'}),
                             required=True)
    password = forms.CharField(label=_("Inserte su contraseña de acceso"),
                               widget=forms.PasswordInput(attrs={'class': 'form-control'}),
                               required=True)
    email = forms.CharField(label=_("Inserte su correo electrónico"),
                            widget=forms.TextInput(attrs={'class': 'form-control'}),
                            required=True)
    telefono = forms.CharField(label=_("Inserte su teléfono"),
                               widget=forms.TextInput(attrs={'class': 'form-control'}),
                               required=False)

    def __init__(self, *args, **kwargs):
        super(RegistroForm, self).__init__(*args, **kwargs)
        self.initial = {
            'nombre': config.CLIENT_NAME,
            'email': config.CLIENT_EMAIL,
            'telefono': config.CLIENT_PHONE,
        }
