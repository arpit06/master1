# -*- coding: utf-8 -*-
# Generated by Django 1.9 on 2017-04-15 18:23
from __future__ import unicode_literals

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('website', '0006_auto_20170408_1459'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='claim',
            options={'managed': False},
        ),
        migrations.AlterModelOptions(
            name='patient',
            options={'managed': False},
        ),
        migrations.AlterModelOptions(
            name='provider',
            options={'managed': False},
        ),
        migrations.AlterModelOptions(
            name='staff',
            options={'managed': False},
        ),
    ]