#!/bin/bash

if [ $(grep -c 'health-check' pom.xml) -eq 0 ]; then
 echo "please add the healthcheck jar to the pom.xml"
 exit 1
fi

