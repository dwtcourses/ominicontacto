# -*- coding: utf-8 -*-
# Generated by Django 1.9.7 on 2019-05-06 20:24
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ominicontacto_app', '0021_sistemaexterno'),
    ]

    operations = [
        migrations.AddField(
            model_name='contacto',
            name='id_externo',
            field=models.CharField(max_length=128, null=True),
        ),
    ]