#!/bin/sh

set -e

aws sns publish \
--topic-arn="$(terraform output -raw job_notification_topic_arn)" \
--message="{\"job\": \"db_migrate\", \"timestamp\": \"$(date +%s)\"}"