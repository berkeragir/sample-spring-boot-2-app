#!/bin/bash

oc new-project java-test

oc new-app --code=https://github.com/schen1/monitoring.git  --name=java-application --image-stream=openshift/java --context-dir=person-application

# scrape metrics
oc patch dc java-application -p '{"spec":{"template":{"metadata":{"labels":{"application":"java-application"}}}}}'
oc patch dc java-application -p '{"spec":{"template":{"metadata":{"annotations":{"prometheus.io/path":"/actuator/prometheus"}}}}}'
oc patch dc java-application -p '{"spec":{"template":{"metadata":{"annotations":{"prometheus.io/port":"8080"}}}}}'
oc patch dc java-application -p '{"spec":{"template":{"metadata":{"annotations":{"prometheus.io/scrape":"true"}}}}}'

# probe service with blackbox exporter
oc annotate svc java-application prometheus.io/probe=true