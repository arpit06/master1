# -*- coding: utf-8 -*-
# Generated by Django 1.10.5 on 2017-04-08 18:54
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('website', '0002_provider'),
    ]

    operations = [
        migrations.CreateModel(
            name='Service',
            fields=[
                ('ServiceTypeId', models.CharField(max_length=10, primary_key=True, serialize=False)),
                ('TypeName', models.CharField(max_length=50)),
                ('ServiceCategory', models.CharField(max_length=50)),
            ],
        ),
    ]
