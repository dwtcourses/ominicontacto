# -*- coding: utf-8 -*-

"""
Tests relacionados con las grabaciones
"""
# -*- coding: utf-8 -*-

from __future__ import unicode_literals

import json

from django.core.urlresolvers import reverse

from ominicontacto_app.models import Grabacion, GrabacionMarca

from ominicontacto_app.tests.factories import GrabacionFactory, GrabacionMarcaFactory, UserFactory
from ominicontacto_app.tests.utiles import OMLBaseTest


class GrabacionesTests(OMLBaseTest):

    PWD = 'admin123'

    def setUp(self):
        self.usuario_admin_supervisor = UserFactory(is_staff=True, is_supervisor=True)
        self.usuario_admin_supervisor.set_password(self.PWD)
        self.usuario_admin_supervisor.save()

        self.grabacion1 = GrabacionFactory.create()
        self.grabacion2 = GrabacionFactory.create()
        self.grabacion3 = GrabacionFactory.create()
        self.marca_campana1 = GrabacionMarcaFactory.create(uid=self.grabacion1.uid)
        self.marca_campana2 = GrabacionMarcaFactory.create(uid=self.grabacion2.uid)

        self.client.login(username=self.usuario_admin_supervisor.username,
                          password=self.PWD)

    def test_filtro_grabaciones_marcadas(self):
        self.assertEqual(Grabacion.objects.marcadas().count(), 2)

    def test_vista_creacion_grabaciones_marcadas(self):
        url = reverse('grabacion_marcar')
        descripcion = 'descripcion de prueba'
        post_data = {'uid': self.grabacion3.uid,
                     'descripcion': descripcion}
        self.client.post(url, post_data)

        self.assertTrue(GrabacionMarca.objects.filter(
            uid=self.grabacion3.uid, descripcion=descripcion).exists())

    def test_usuarios_no_logueados_no_acceden_a_vista_creacion_grabaciones_marcadas(self):
        self.client.logout()
        url = reverse('grabacion_marcar')
        descripcion = 'descripcion de prueba'
        post_data = {'uid': self.grabacion3.uid,
                     'descripcion': descripcion}
        self.client.post(url, post_data)
        self.assertFalse(GrabacionMarca.objects.filter(
            uid=self.grabacion3.uid, descripcion=descripcion).exists())

    def test_usuarios_no_logueados_no_acceden_a_obtener_descripciones_grabaciones(self):
        self.client.logout()
        url = reverse('grabacion_descripcion', kwargs={'uid': self.grabacion1.uid})
        response = self.client.get(url, follow=True)
        self.assertEqual(response.template_name, 'registration/login.html')

    def test_respuesta_api_descripciones_grabaciones_marcadas(self):
        url = reverse('grabacion_descripcion', kwargs={'uid': self.grabacion2.uid})
        response = self.client.get(url, follow=True)
        data_response = json.loads(response.content)
        self.assertEqual(data_response['result'], 'Descripción')

    def test_respuesta_api_descripciones_grabaciones_no_marcadas(self):
        url = reverse('grabacion_descripcion', kwargs={'uid': self.grabacion3.uid})
        response = self.client.get(url, follow=True)
        data_response = json.loads(response.content)
        self.assertEqual(data_response['result'], 'No encontrada')