from django.contrib import admin
from .models import Staff, Customer
from django.contrib.auth.hashers import make_password

@admin.register(Staff)
class StaffAdmin(admin.ModelAdmin):
    list_display = ('name', 'email', 'role')  # Show these fields in the admin list view

    def save_model(self, request, obj, form, change):
        # If the password was changed or set, hash it before saving
        if form.cleaned_data.get('password'):
            obj.password = make_password(form.cleaned_data['password'])
        super().save_model(request, obj, form, change)

admin.site.register(Customer)
