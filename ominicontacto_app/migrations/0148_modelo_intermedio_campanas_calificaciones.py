# -*- coding: utf-8 -*-
# Generated by Django 1.9.7 on 2018-01-30 21:47
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('ominicontacto_app', '0147_permite_nulidad_calificacion_campana'),
    ]

    operations = [
        migrations.CreateModel(
            name='OpcionCalificacion',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False,
                                        verbose_name='ID')),
                ('opcion', models.IntegerField(choices=[(1, 'Gesti\xf3n')], default=0)),
                ('calificacion', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE,
                                                   to='ominicontacto_app.Calificacion')),
                ('campana', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE,
                                              to='ominicontacto_app.Campana')),
            ],
        ),
        migrations.AddField(
            model_name='campana',
            name='calificaciones_campana',
            field=models.ManyToManyField(related_name='campanas',
                                         through='ominicontacto_app.OpcionCalificacion',
                                         to='ominicontacto_app.Calificacion'),
        ),
    ]
