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

"""Vistas genéricas de reportes de campañas"""

from __future__ import unicode_literals

import datetime

from django.shortcuts import redirect
from django.views.generic import FormView, ListView, View
from django.utils import timezone
from django.contrib import messages
from django.utils.translation import ugettext_lazy as _

from ominicontacto_app.forms import ReporteCampanaForm
from ominicontacto_app.models import Campana, AgenteProfile
from ominicontacto_app.services.estadisticas_campana import EstadisticasService
from ominicontacto_app.services.reporte_agente import EstadisticasAgenteService
from ominicontacto_app.services.reporte_campana_calificacion import ReporteCampanaService
from ominicontacto_app.services.reporte_campana_pdf import ReporteCampanaPDFService
from reportes_app.reportes.reporte_llamados_contactados_csv import ExportacionCampanaCSV
from ominicontacto_app.services.reporte_respuestas_formulario import (
    ReporteRespuestaFormularioGestionService)
from ominicontacto_app.utiles import convert_fecha_datetime, fecha_hora_local


class CampanaReporteCalificacionListView(ListView):
    """
    Muestra un listado de contactos a los cuales se los calificaron en la campana
    """
    template_name = 'calificaciones_campana.html'
    context_object_name = 'campana'
    model = Campana

    def get(self, request, *args, **kwargs):
        user = request.user
        asignadas = Campana.objects.all()

        if not user.get_is_administrador():
            supervisor = user.get_supervisor_profile()
            asignadas = supervisor.campanas_asignadas_actuales()

        try:
            self.campana = asignadas.get(pk=self.kwargs['pk_campana'])
        except Campana.DoesNotExist:
            messages.warning(self.request, _(u"Usted no puede acceder a esta campaña."))
            return redirect('index')

        return super(CampanaReporteCalificacionListView, self).get(self, request, *args, **kwargs)

    def get_context_data(self, **kwargs):
        context = super(CampanaReporteCalificacionListView, self).get_context_data(
            **kwargs)

        service = ReporteCampanaService(self.campana)
        calificaciones_qs = service.calificaciones_qs
        service.crea_reporte_csv()

        service_formulario = ReporteRespuestaFormularioGestionService()
        service_formulario.crea_reporte_csv(self.campana)

        context['campana'] = self.campana
        context['calificaciones'] = calificaciones_qs
        return context


class ExportaCampanaReporteCalificacionView(View):
    """
    Esta vista invoca a generar un csv de reporte de la campana.
    """

    model = Campana
    context_object_name = 'campana'

    def get_object(self, queryset=None):
        return Campana.objects.get(pk=self.kwargs['pk_campana'])

    def get(self, request, *args, **kwargs):
        self.object = self.get_object()

        service = ReporteCampanaService(self.object)
        url = service.obtener_url_reporte_csv_descargar()

        return redirect(url)


class ExportaReporteFormularioVentaView(View):
    """
    Esta vista invoca a generar un csv de reporte de la la venta.
    """

    model = Campana
    context_object_name = 'campana'

    def get_object(self, queryset=None):
        return Campana.objects.get(pk=self.kwargs['pk_campana'])

    def get(self, request, *args, **kwargs):
        self.object = self.get_object()

        service = ReporteRespuestaFormularioGestionService()
        url = service.obtener_url_reporte_csv_descargar(self.object)

        return redirect(url)


class CampanaReporteGraficoView(FormView):
    """Esta vista genera el reporte grafico de la campana"""

    context_object_name = 'campana'
    model = Campana
    form_class = ReporteCampanaForm
    template_name = 'reporte_grafico_campana.html'

    def get_object(self, queryset=None):
        user = self.request.user

        asignadas = Campana.objects.all()

        if not user.get_is_administrador():
            supervisor = user.get_supervisor_profile()
            asignadas = supervisor.campanas_asignadas_actuales()

        try:
            return asignadas.get(pk=self.kwargs['pk_campana'])
        except Campana.DoesNotExist:
            return None

    def get(self, request, *args, **kwargs):
        campana = self.get_object()
        if not campana:
            messages.warning(self.request, _(u"Usted no puede acceder a esta campaña."))
            return redirect('index')
        hoy_ahora = fecha_hora_local(timezone.now())
        hoy = hoy_ahora.date()
        fecha_desde = datetime.datetime.combine(hoy, datetime.time.min)
        fecha_hasta = datetime.datetime.combine(hoy_ahora, datetime.time.max)
        service = EstadisticasService(campana, fecha_desde, fecha_hasta)
        # genera los reportes grafico de la campana
        graficos_estadisticas = service.general_campana()
        # generar el reporte pdf
        service_pdf = ReporteCampanaPDFService()
        service_pdf.crea_reporte_pdf(campana, graficos_estadisticas)
        return self.render_to_response(self.get_context_data(
            graficos_estadisticas=graficos_estadisticas,
            pk_campana=self.kwargs['pk_campana']))

    def get_context_data(self, **kwargs):
        context = super(CampanaReporteGraficoView, self).get_context_data(
            **kwargs)
        campana = self.get_object()
        context['campana'] = campana
        context['campana_entrante'] = (campana.type == Campana.TYPE_ENTRANTE)
        return context

    def form_valid(self, form):
        fecha = form.cleaned_data.get('fecha')
        fecha_desde, fecha_hasta = fecha.split('-')
        fecha_desde = convert_fecha_datetime(fecha_desde)
        fecha_hasta = convert_fecha_datetime(fecha_hasta)
        fecha_desde = datetime.datetime.combine(fecha_desde, datetime.time.min)
        fecha_hasta = datetime.datetime.combine(fecha_hasta, datetime.time.max)
        # generar el reporte grafico de acuerdo al periodo de fecha seleccionado
        service = EstadisticasService(self.get_object(), fecha_desde, fecha_hasta)
        graficos_estadisticas = service.general_campana()
        # genera el reporte pdf de la campana
        service_pdf = ReporteCampanaPDFService()
        service_pdf.crea_reporte_pdf(self.get_object(), graficos_estadisticas)
        return self.render_to_response(self.get_context_data(
            graficos_estadisticas=graficos_estadisticas,
            pk_campana=self.kwargs['pk_campana']))


class ExportaCampanaReporteGraficoPDFView(View):
    """
    Esta vista invoca a generar un pdf de reporte de la campana
    """

    model = Campana
    context_object_name = 'campana'

    def get_object(self, queryset=None):
        return Campana.objects.get(pk=self.kwargs['pk_campana'])

    def get(self, request, *args, **kwargs):
        self.object = self.get_object()
        service = ReporteCampanaPDFService()
        url = service.obtener_url_reporte_pdf_descargar(self.object)
        return redirect(url)


class ExportaReporteLlamadosContactadosView(View):
    """
    Esta vista invoca a generar un csv de reporte de la campana.
    """

    model = Campana
    context_object_name = 'campana'

    def get_object(self, queryset=None):
        return Campana.objects.get(pk=self.kwargs['pk_campana'])

    def get(self, request, *args, **kwargs):
        self.object = self.get_object()
        service_csv = ExportacionCampanaCSV()
        url = service_csv.obtener_url_reporte_csv_descargar(
            self.object, "contactados")

        return redirect(url)


class ExportaReporteNoAtendidosView(View):
    """
    Esta vista invoca a generar un csv de reporte de la campana.
    """

    model = Campana
    context_object_name = 'campana'

    def get_object(self, queryset=None):
        return Campana.objects.get(pk=self.kwargs['pk_campana'])

    def get(self, request, *args, **kwargs):
        self.object = self.get_object()
        service_csv = ExportacionCampanaCSV()
        url = service_csv.obtener_url_reporte_csv_descargar(
            self.object, "no_atendidos")

        return redirect(url)


class ExportaReporteCalificadosView(View):
    """
    Esta vista invoca a generar un csv de reporte de la campana.
    """

    model = Campana
    context_object_name = 'campana'

    def get_object(self, queryset=None):
        return Campana.objects.get(pk=self.kwargs['pk_campana'])

    def get(self, request, *args, **kwargs):
        self.object = self.get_object()
        service_csv = ExportacionCampanaCSV()
        url = service_csv.obtener_url_reporte_csv_descargar(
            self.object, "calificados")

        return redirect(url)


class AgenteCampanaReporteGrafico(FormView):
    """Esta vista genera el reporte grafico de la campana para un agente"""
    template_name = 'reporte_agente.html'
    form_class = ReporteCampanaForm

    def get_object(self, queryset=None):
        return Campana.objects.get(pk=self.kwargs['pk_campana'])

    def get(self, request, *args, **kwargs):
        service = EstadisticasAgenteService()
        hoy_ahora = datetime.datetime.today()
        hoy = hoy_ahora.date()
        agente = AgenteProfile.objects.get(pk=self.kwargs['pk_agente'])
        # generar el reporte para el agente de la campana
        graficos_estadisticas = service.general_campana(agente,
                                                        self.get_object(), hoy,
                                                        hoy_ahora)
        return self.render_to_response(self.get_context_data(
            graficos_estadisticas=graficos_estadisticas))

    def get_context_data(self, **kwargs):
        context = super(AgenteCampanaReporteGrafico, self).get_context_data(
            **kwargs)

        agente = AgenteProfile.objects.get(pk=self.kwargs['pk_agente'])
        context['pk_campana'] = self.kwargs['pk_campana']

        context['agente'] = agente
        return context

    def form_valid(self, form):
        fecha = form.cleaned_data.get('fecha')
        fecha_desde, fecha_hasta = fecha.split('-')
        fecha_desde = convert_fecha_datetime(fecha_desde)
        fecha_hasta = convert_fecha_datetime(fecha_hasta)
        # genera el reporte para el agente de esta campana
        service = EstadisticasAgenteService()
        agente = AgenteProfile.objects.get(pk=self.kwargs['pk_agente'])
        graficos_estadisticas = service.general_campana(agente,
                                                        self.get_object(),
                                                        fecha_desde,
                                                        fecha_hasta)
        return self.render_to_response(self.get_context_data(
            graficos_estadisticas=graficos_estadisticas))
