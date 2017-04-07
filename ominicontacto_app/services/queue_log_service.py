# -*- coding: utf-8 -*-

from __future__ import unicode_literals

from django.db import connection

import datetime
import logging


logger = logging.getLogger(__name__)


class AgenteTiemposReporte(object):
    """Encapsula los datos de los tiempos de sesion, pausa y llamada del agente.
    """

    def __init__(self, agente, tiempo_sesion, tiempo_pausa, tiempo_llamada):

        self._agente = agente
        self._tiempo_sesion = tiempo_sesion
        self._tiempo_pausa = tiempo_pausa
        self._tiempo_llamada = tiempo_llamada

    @property
    def agente(self):
        return self._agente

    @property
    def tiempo_sesion(self):
        return self._tiempo_sesion

    @property
    def tiempo_pausa(self):
        return self._tiempo_pausa

    @property
    def tiempo_llamada(self):
        return self._tiempo_llamada

    @property
    def tiempo_porcentaje_llamada(self):
        if self.tiempo_llamada and  self.tiempo_sesion:
            return self.tiempo_llamada / self.tiempo_sesion.total_seconds()
        return None

    @property
    def tiempo_porcentaje_pausa(self):
        if self.tiempo_pausa and  self.tiempo_sesion:
            return self.tiempo_pausa.total_seconds() / self.tiempo_sesion.total_seconds()
        return None

    @property
    def tiempo_wait(self):
        if self.tiempo_sesion:
            tiempo_wait = self.tiempo_sesion.total_seconds()
            if self.tiempo_pausa:
                tiempo_wait -= self.tiempo_pausa.total_seconds()
            if self.tiempo_llamada:
                tiempo_wait -= self.tiempo_llamada
            return tiempo_wait
        else:
            return None

    @property
    def tiempo_porcentaje_wait(self):
        if self.tiempo_wait and  self.tiempo_sesion:
            return self.tiempo_wait / self.tiempo_sesion.total_seconds()
        return None

    def get_string_tiempo_sesion(self):
        if self.tiempo_sesion:
            return str(datetime.timedelta(seconds=self.tiempo_sesion.seconds))
        return self.tiempo_sesion

    def get_string_tiempo_llamada(self):
        if self.tiempo_llamada:
            return datetime.timedelta(0, self.tiempo_llamada)
        return self.tiempo_llamada