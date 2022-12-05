#!/bin/sh

set -e

aws sns subscribe \
--topic-arn="$(terraform output -raw job_notification_topic_arn)" \
--protocol="https" \
--notification-endpoint="$(terraform output -raw job_notification_endpoint)" 