from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^staff/add/$', views.StaffCreate.as_view(), name='add-staff'),
    url(r'^patient/add/$', views.PatientCreate.as_view(), name='create-patient'),
    url(r'^provider/add/$', views.ProviderCreate.as_view(), name='create-provider'),
    url(r'^provider/view/$', views.ProviderRead.as_view(), name='view-provider'),
    url(r'^provider/delete/(?P<pk>\w+)$', views.ProviderDelete.as_view(), name='delete-provider'),
    url(r'^provider/update/(?P<pk>\w+)$', views.ProviderUpdate.as_view(), name='update-provider'),
    url(r'^staff/view/$', views.StaffRead.as_view(), name='view-staff'),
    url(r'^staff/delete/(?P<pk>\w+)$', views.StaffDelete.as_view(), name='delete-staff'),
    url(r'^staff/update/(?P<pk>\w+)$', views.StaffUpdate.as_view(), name='update-staff'),
]