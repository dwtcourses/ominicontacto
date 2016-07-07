# -*- coding: utf-8 -*-
# Generated by Django 1.9.7 on 2016-07-07 16:09
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion
import django.db.models.manager


class Migration(migrations.Migration):

    dependencies = [
        ('ominicontacto_app', '0005_user_node_password'),
    ]

    operations = [
        migrations.CreateModel(
            name='MensajeEnviado',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('remitente', models.CharField(max_length=20)),
                ('destinatario', models.CharField(max_length=20)),
                ('timestamp', models.CharField(max_length=255)),
                ('content', models.TextField()),
                ('result', models.IntegerField(blank=True, null=True)),
                ('agente', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='ominicontacto_app.AgenteProfile')),
            ],
            options={
                'db_table': 'mensaje_enviado',
            },
        ),
        migrations.CreateModel(
            name='MensajeRecibido',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('remitente', models.CharField(max_length=20)),
                ('destinatario', models.CharField(max_length=20)),
                ('timestamp', models.CharField(max_length=255)),
                ('timezone', models.IntegerField()),
                ('encoding', models.IntegerField()),
                ('content', models.TextField()),
                ('es_leido', models.BooleanField(default=False)),
            ],
            options={
                'db_table': 'mensaje_recibido',
            },
            managers=[
                ('objects_default', django.db.models.manager.Manager()),
            ],
        ),
    ]
