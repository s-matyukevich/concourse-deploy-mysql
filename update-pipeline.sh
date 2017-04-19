#!/bin/bash

fly -t cp set-pipeline -p deploy-mysql -c ci/mysql-pipeline.yml -l setup/pipeline-vars.yml
