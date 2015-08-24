__author__ = 'I302520'

from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^segment$', views.segment, name='segment'),
]