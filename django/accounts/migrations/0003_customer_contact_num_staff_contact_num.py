# Generated by Django 5.2.4 on 2025-07-14 10:01

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0002_staff_name'),
    ]

    operations = [
        migrations.AddField(
            model_name='customer',
            name='contact_num',
            field=models.CharField(blank=True, max_length=20, null=True),
        ),
        migrations.AddField(
            model_name='staff',
            name='contact_num',
            field=models.CharField(blank=True, max_length=20, null=True),
        ),
    ]
