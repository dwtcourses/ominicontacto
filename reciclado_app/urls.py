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
from reciclado_app import views

urlpatterns = [
    url(r'^reciclar/(?P<pk_campana>\d+)/dialer/$',
        login_required(views.ReciclarCampanaDialerFormView.as_view()),
        name='reciclar_campana_dialer'),
    url(r'^reciclar/(?P<pk_campana>\d+)/preview/$',
        login_required(views.ReciclarCampanaPreviewFormView.as_view()),
        name='reciclar_campana_preview'),
]
