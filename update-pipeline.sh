#!/bin/bash

fly -t cp set-pipeline -p $1-deploy-mysql -c ci/mysql-pipeline.yml -l setup/pipeline-vars.yml
