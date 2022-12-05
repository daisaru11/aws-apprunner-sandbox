# aws-apprunner-sandbox

An example repository of Ruby on Rails application including the deployment configurations to [AWS App Runner](https://aws.amazon.com/jp/apprunner/).

## Deploy

```
cd terraform

terraform init
terraform apply

./subscribe_job_notification.sh

./submit_job_db_migrate.sh
./submit_job_db_seed.sh
```

