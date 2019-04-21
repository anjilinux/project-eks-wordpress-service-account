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

# Manual deployment
If you're deploying this stack "by hand" comment out "EKSAccessUser" section.

# Automatic deployment

## Kubernetes initial configuration
Use this instruction only if you are deploying this stack non-manually.

To initially configure Kubernetes cluster you have to use the same role that
was used to create cluster. This is the only way to access the cluster.

This stack creates such user. To find the user in IAM check "Outputs" section of the
stack and use "EKSAccessUserName" value.

Next thing you have to do is to make sure you have CLI access to your AWS
account using this user. You can obtain CLI credentials using IAM web console.

Next, create profile that will be used with kubectl commands. You can create
profile in your $HOME/.aws/config file. It can looks like the one below.

```
[default]
region = us-east-1
output = json

[profile eksaccess]
region = us-east-1
output = json
role_arn = arn:aws:iam::<account_number>:role/Actual_Pipeline_Cloudformation_deployment_role
source_profile = default
```

Details on https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-cli.html?shortFooter=true

Also, add `sts:assumeRole` to the deployment role's trust relationship just after
"PipelineRole" record:
```
{
  "Effect": "Allow",
  "Principal": {
    "AWS": "arn:aws:iam::<account number>:user/<username>"
  },
  "Action": "sts:AssumeRole"
}
```
Then, make sure the `kubectl` and `aws-iam-authenticator` are available in your
terminal. You can follow this link
https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html section
"Step 2: Create a kubeconfig File "

On the end run (example):
```
aws --profile eksaccess eks --region us-east-1 update-kubeconfig --name <cluster name>
```
to configure kubeconfig file.
