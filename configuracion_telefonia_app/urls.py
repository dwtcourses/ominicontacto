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

from django.conf.urls import url
from django.contrib.auth.decorators import login_required

from configuracion_telefonia_app.views import base, audio


urlpatterns = [
    url(r'^configuracion_telefonia/troncal_sip/lista/page(?P<page>[0-9]+)/$',
        login_required(base.TroncalSIPListView.as_view()),
        name='lista_troncal_sip',
        ),
    url(r'^configuracion_telefonia/troncal_sip/crear/$',
        login_required(base.TroncalSIPCreateView.as_view()),
        name='crear_troncal_sip',
        ),
    url(r'^configuracion_telefonia/troncal_sip/(?P<pk>\d+)/editar/$',
        login_required(base.TroncalSIPUpdateView.as_view()),
        name='editar_troncal_sip',
        ),
    url(r'^configuracion_telefonia/troncal_sip/(?P<pk>\d+)/eliminar/$',
        login_required(base.TroncalSIPDeleteView.as_view()),
        name='eliminar_troncal_sip',
        ),
    url(r'^configuracion_telefonia/ruta_saliente/lista/page(?P<page>[0-9]+)/$',
        login_required(base.RutaSalienteListView.as_view()),
        name='lista_rutas_salientes',
        ),
    url(r'^configuracion_telefonia/ruta_saliente/ordenar/$',
        login_required(base.OrdenarRutasSalientesView.as_view()),
        name='ordenar_rutas_salientes',
        ),
    url(r'^configuracion_telefonia/ruta_saliente/crear/$',
        login_required(base.RutaSalienteCreateView.as_view()),
        name='crear_ruta_saliente',
        ),
    url(r'^configuracion_telefonia/ruta_saliente/(?P<pk>\d+)/editar/$',
        login_required(base.RutaSalienteUpdateView.as_view()),
        name='editar_ruta_saliente'),
    url(r'^configuracion_telefonia/ruta_saliente/eliminar/(?P<pk>\d+)/$',
        login_required(base.EliminarRutaSaliente.as_view()),
        name='eliminar_ruta_saliente',
        ),
    url(r'^configuracion_telefonia/ruta_entrante/lista/page(?P<page>[0-9]+)/$',
        login_required(base.RutaEntranteListView.as_view()),
        name='lista_rutas_entrantes',
        ),
    url(r'^configuracion_telefonia/ruta_entrante/crear/$',
        login_required(base.RutaEntranteCreateView.as_view()),
        name='crear_ruta_entrante',
        ),
    url(r'^configuracion_telefonia/ruta_entrante/(?P<pk>\d+)/editar/$',
        login_required(base.RutaEntranteUpdateView.as_view()),
        name='editar_ruta_entrante',
        ),
    url(r'^configuracion_telefonia/ruta_entrante/(?P<pk>\d+)/eliminar/$',
        login_required(base.RutaEntranteDeleteView.as_view()),
        name='eliminar_ruta_entrante',
        ),
    url(r'^configuracion_telefonia/ruta_entrante/obtener_destinos_tipo/(?P<tipo_destino>\d+)/$',
        login_required(base.ApiObtenerDestinosEntrantes.as_view()),
        name='obtener_destinos_tipo',
        ),
    url(r'^configuracion_telefonia/ivr/lista/page(?P<page>[0-9]+)/$',
        login_required(base.IVRListView.as_view()),
        name='lista_ivrs',
        ),
    url(r'^configuracion_telefonia/ivr/crear/$',
        login_required(base.IVRCreateView.as_view()),
        name='crear_ivr',
        ),
    url(r'^configuracion_telefonia/ivr/(?P<pk>\d+)/editar/$',
        login_required(base.IVRUpdateView.as_view()),
        name='editar_ivr',
        ),
    url(r'^configuracion_telefonia/ivr/(?P<pk>\d+)/eliminar/$',
        login_required(base.IVRDeleteView.as_view()),
        name='eliminar_ivr',
        ),
    url(r'^configuracion_telefonia/grupo_horario/lista/page(?P<page>[0-9]+)/$',
        login_required(base.GrupoHorarioListView.as_view()),
        name='lista_grupos_horarios',
        ),
    url(r'^configuracion_telefonia/grupo_horario/crear/$',
        login_required(base.GrupoHorarioCreateView.as_view()),
        name='crear_grupo_horario',
        ),
    url(r'^configuracion_telefonia/grupo_horario/(?P<pk>\d+)/editar/$',
        login_required(base.GrupoHorarioUpdateView.as_view()),
        name='editar_grupo_horario',
        ),
    url(r'^configuracion_telefonia/grupo_horario/(?P<pk>\d+)/eliminar/$',
        login_required(base.GrupoHorarioDeleteView.as_view()),
        name='eliminar_grupo_horario',
        ),
    url(r'^configuracion_telefonia/validacion_fecha_hora/lista/page(?P<page>[0-9]+)/$',
        login_required(base.ValidacionFechaHoraListView.as_view()),
        name='lista_validaciones_fecha_hora',
        ),
    url(r'^configuracion_telefonia/validacion_fecha_hora/crear/$',
        login_required(base.ValidacionFechaHoraCreateView.as_view()),
        name='crear_validacion_fecha_hora',
        ),
    url(r'^configuracion_telefonia/validacion_fecha_hora/(?P<pk>\d+)/editar/$',
        login_required(base.ValidacionFechaHoraUpdateView.as_view()),
        name='editar_validacion_fecha_hora',
        ),
    url(r'^configuracion_telefonia/validacion_fecha_hora/(?P<pk>\d+)/eliminar/$',
        login_required(base.ValidacionFechaHoraDeleteView.as_view()),
        name='eliminar_validacion_fecha_hora',
        ),
    url(r'^configuracion_telefonia/identificador_cliente/lista/page(?P<page>[0-9]+)/$',
        login_required(base.IdentificadorClienteListView.as_view()),
        name='lista_identificador_cliente',
        ),
    url(r'^configuracion_telefonia/identificador_cliente/crear/$',
        login_required(base.IdentificadorClienteCreateView.as_view()),
        name='crear_identificador_cliente',
        ),
    url(r'^configuracion_telefonia/identificador_cliente/(?P<pk>\d+)/editar/$',
        login_required(base.IdentificadorClienteUpdateView.as_view()),
        name='editar_identificador_cliente',
        ),
    url(r'^configuracion_telefonia/identificador_cliente/(?P<pk>\d+)/eliminar/$',
        login_required(base.IdentificadorClienteDeleteView.as_view()),
        name='eliminar_identificador_cliente',
        ),
    url(r'^destino_personalizado/lista/page(?P<page>[0-9]+)/$',
        base.DestinoPersonalizadoListView.as_view(),
        name='lista_destinos_personalizados'),
    url(r'^destino_personalizado/crear/$', base.DestinoPersonalizadoCreateView.as_view(),
        name='crear_destino_personalizado'),
    url(r'^destino_personalizado/(?P<pk>\d+)/editar$',
        base.DestinoPersonalizadoUpdateView.as_view(), name='editar_destino_personalizado'),
    url(r'^destino_personalizado/(?P<pk>\d+)/eliminar$',
        base.DestinoPersonalizadoDeleteView.as_view(), name='eliminar_destino_personalizado'),
    url(r'^configuracion_telefonia/adicionar_audios_asterisk/$',
        login_required(audio.AdicionarAudioAsteriskView.as_view()),
        name='adicionar_audios_asterisk',
        ),
    url(r'^configuracion_telefonia/playlist/lista/$',
        login_required(audio.PlaylistListView.as_view()),
        name='lista_playlist',
        ),
    url(r'^configuracion_telefonia/playlist/crear/$',
        login_required(audio.PlaylistCreateView.as_view()),
        name='crear_playlist',
        ),
    url(r'^configuracion_telefonia/playlist/(?P<pk>\d+)/eliminar/$',
        login_required(audio.PlaylistDeleteView.as_view()),
        name='eliminar_playlist',
        ),
    url(r'^configuracion_telefonia/playlist/(?P<pk>\d+)/editar/$',
        login_required(audio.MusicaDeEsperaCreateView.as_view()),
        name='editar_playlist',
        ),
    url(r'^configuracion_telefonia/playlist/(?P<pk>\d+)/remover_musica_de_espera/$',
        login_required(audio.MusicaDeEsperaDeleteView.as_view()),
        name='eliminar_musica_de_espera',
        ),
]
