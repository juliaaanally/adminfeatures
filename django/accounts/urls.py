from django.urls import path
from django.views.decorators.csrf import csrf_exempt
from . import views

urlpatterns = [
    path('register/', views.register_customer),
    path('login/', views.login_user),
    path('forgot-password/', views.forgot_password),
    path('reset-password/<str:token>/', views.reset_password, name='reset-password'),
    path('admin/profile/', csrf_exempt(views.AdminProfileView.as_view()), name='admin-profile'),
    path('admin/change-password/', csrf_exempt(views.ChangeAdminPasswordView.as_view()), name='admin-change-password'),
]
