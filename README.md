# aws-kubernetes-wordpress
Cloudofrmation script to deploy Wordpress on AWS EKS on production (HA) and
development environment with Postgres Aurora.

This stack requires to keep Github token and database secrets in AWS Secrets
Manager. Things to do:
- Create new secret for Github token with one key. You can name the key "Token".
To get token from Github go to https://github.com/settings/tokens and generate
one.
- Create new secret for Wordpress production database credentials with two
keys - username and password.
- Create new secret for Wordpress development database credentials as well.
There should be two keys - username and password.
- Provide secrets' names and keys to the template's parameters before runtime.
