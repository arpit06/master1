from django.shortcuts import render
from django.views.generic.edit import CreateView, UpdateView, DeleteView
from django.views.generic import TemplateView,ListView
from .models import Staff, Patient, Provider
from django.core.urlresolvers import reverse_lazy

# Create your views here.
from django.http import HttpResponse

def index(request):
    return render(request, 'website/index.html')

class StaffCreate(CreateView):
    model = Staff
    fields = ['StaffId', 'FirstName', 'LastName', 'StaffRole','Susername', 'Spassword']

class StaffRead(ListView):
    model = Staff

class StaffUpdate(UpdateView):
    model = Staff
    success_url = reverse_lazy('view-staff')
    fields = ['StaffId', 'FirstName', 'LastName', 'StaffRole', 'Susername', 'Spassword']


class StaffDelete(DeleteView):
    model = Staff
    success_url = reverse_lazy('view-staff')


class PatientCreate(CreateView):
    model = Patient
    fields = ['PatientID', 'FirstName', 'LastName', 'Gender','PatientAddress', 'City', 'PatientState', 'ZipCode',
              'PhoneNumber','DateOfBirth','Employment','Age']


class ProviderCreate(CreateView):
    model = Provider
    fields = ['ProviderID','ProviderName','ProviderType','NetworkType','ProviderAddress','City','ProviderState',
              'ZipCode','PhoneNumber']

class ProviderRead(ListView):
    model = Provider

class ProviderUpdate(UpdateView):
    model = Provider
    success_url = reverse_lazy('view-provider')
    fields = ['ProviderID', 'ProviderName', 'ProviderType', 'NetworkType', 'ProviderAddress', 'City', 'ProviderState',
              'ZipCode', 'PhoneNumber']


class ProviderDelete(DeleteView):
    model = Provider
    success_url = reverse_lazy('view-provider')
