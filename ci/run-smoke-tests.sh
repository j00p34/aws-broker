#!/bin/bash

set -e

cf login -a $CF_API_URL -u $CF_DEPLOY_USERNAME -p $CF_DEPLOY_PASSWORD -o $CF_ORGANIZATION -s $CF_SPACE

cf create-service aws-rds $SERVICE_PLAN rds-smoke-tests-$SERVICE_PLAN

cat << EOF > aws-broker-app/ci/smoke-tests/manifest.yml
---
applications:
- name: smoke-tests-$SERVICE_PLAN
  buildpack: binary_buildpack
  command: ./smoke-tests.sh
  env:
    DB_TYPE: $DB_TYPE
  services:
  - rds-smoke-tests-$SERVICE_PLAN
EOF

while true; do
  if OUT=`cf push -f aws-broker-app/ci/smoke-tests/manifest.yml -p aws-broker-app/ci/smoke-tests` ; then
    break
  fi
  if ! echo $OUT | grep "Instance not available yet" ; then
    echo $OUT
    exit 1
  fi
  sleep 90
done

cf delete -f smoke-tests-$SERVICE_PLAN
cf delete-service -f rds-smoke-tests-$SERVICE_PLAN
