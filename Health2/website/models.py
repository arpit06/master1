from django.db import models

# Create your models here.
from django.db import models
from django.core.urlresolvers import reverse


class Staff(models.Model):
    StaffId = models.CharField(max_length=20, primary_key= True)
    FirstName = models.CharField(max_length=50)
    LastName = models.CharField(max_length=50)
    StaffRole = models.CharField(max_length=50)
    Susername = models.CharField(max_length=50)
    Spassword = models.CharField(max_length=50)
    def __str__(self):
        return self.FirstName+" "+ self.LastName

    def get_absolute_url(self):
        return reverse ('index')

    class Meta:
        managed = False
        db_table = 'Staff'
        app_label = 'website'

class Provider(models.Model):
    ProviderID = models.CharField(max_length=20, primary_key = True)
    ProviderName = models.CharField(max_length=50)
    ProviderType = models.CharField(max_length=50)
    NetworkType = models.CharField(max_length=50)
    ProviderAddress = models.CharField(max_length=50)
    City = models.CharField(max_length=50)
    ProviderState = models.CharField(max_length=50)
    ZipCode = models.IntegerField(default=0)
    PhoneNumber = models.IntegerField(default=0)

    def __str__(self):
        return self.ProviderName+" "+ self.ProviderType

    def get_absolute_url(self):
        return reverse ('index')

    class Meta:
        managed = False
        db_table = 'Provider'
        app_label = 'website'

class Service(models.Model):
    ServiceTypeId = models.CharField(max_length=10, primary_key = True)
    TypeName =  models.CharField(max_length=50)
    ServiceCategory = models.CharField(max_length=50)


class Patient(models.Model):
    PatientID = models.CharField(max_length=20, primary_key=True)
    FirstName = models.CharField(max_length=50)
    LastName = models.CharField(max_length=50)
    Gender = models.CharField(max_length=50)
    PatientAddress = models.CharField(max_length=50)
    City = models.CharField(max_length=50)
    PatientState = models.CharField(max_length=50)
    ZipCode = models.IntegerField(default=0)
    PhoneNumber = models.IntegerField(default=0)
    DateOfBirth = models.DateTimeField()
    Employment = models.BooleanField(default = True)
    Age = models.IntegerField(default=0)

    def __str__(self):
        return self.FirstName+" "+ self.LastName

    def get_absolute_url(self):
        return reverse ('index')

    class Meta:
        managed = False
        db_table = 'Patient'
        app_label = 'website'


class Policy(models.Model):
    PolicyId = models.CharField(max_length=20, primary_key=True)
    PolicyName = models.CharField(max_length=50)
    PolicyDuration = models.IntegerField(default=0)
    PolicyType = models.CharField(max_length=50)
    PatientId = models.ForeignKey(Patient, on_delete=models.CASCADE)

class ReasonForDenial(models.Model):
    ReasonId = models.CharField(max_length=20, primary_key=True)
    Description = models.CharField(max_length=200)

class Claim(models.Model):
    ClaimId = models.CharField(max_length=20, primary_key=True)
    ClaimDate = models.DateTimeField()
    HospitalStartDate = models.DateTimeField()
    HospitalEndDate = models.DateTimeField()
    PatientCoPay = models.IntegerField(default=0)
    ProviderId = models.ForeignKey(Provider, on_delete=models.CASCADE)
    def __str__(self):
        return self.FirstName+" "+ self.LastName

    def get_absolute_url(self):
        return reverse ('index')

    class Meta:
        managed = False
        db_table = 'Staff'
        app_label = 'website'


class Condition(models.Model):
    ConditionId = models.CharField(max_length=20, primary_key=True)
    ServiceId = models.ForeignKey(Service, on_delete=models.CASCADE)
    PolicyId = models.ForeignKey(Policy, on_delete=models.CASCADE)

class ServiceReceived(models.Model):
    ServiceId = models.CharField(max_length=20, primary_key=True)
    ServiceStartDate = models.DateTimeField()
    ServiceEndDate = models.DateTimeField()
    ServiceName = models.CharField(max_length=20)
    ServiceCost = models.IntegerField(default=0)
    PatientId = models.ForeignKey(Patient, on_delete=models.CASCADE)
    ProviderId = models.ForeignKey(Provider, on_delete=models.CASCADE)
    ClaimId = models.ForeignKey(Claim, on_delete=models.CASCADE)
    ServiceTypeId = models.ForeignKey(Service, on_delete=models.CASCADE)
    PolicyId = models.ForeignKey(Policy, on_delete=models.CASCADE)

class ClaimProcessing(models.Model):
    ClaimProcessingId = models.CharField(max_length=20, primary_key=True)
    Status = models.CharField(max_length=20)
    OpenDate = models.DateTimeField()
    ReviewDate = models.DateTimeField()
    ApprovedDate = models.DateTimeField()
    DenyDate = models.DateTimeField()
    RepealDate = models.DateTimeField()
    RejectDate = models.DateTimeField()
    Notes = models.CharField(max_length=20)
    StaffId = models.ForeignKey(Staff, on_delete=models.CASCADE)
    ClaimId = models.ForeignKey(Claim, on_delete=models.CASCADE)
    ReasonId = models.ForeignKey(ReasonForDenial, on_delete=models.CASCADE)










