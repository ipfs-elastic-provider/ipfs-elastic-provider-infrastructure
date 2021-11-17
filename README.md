# AWS-IPFS-Infrastructure

## Description

`AWS-IPFS-Infrastructure` is the automation responsible for provisioning the required infrastructure for the `AWS-IPFS` project.

## Terraform

### Prerequisites

- Terraform version >= v1.x.x.
- Configured AWS Credentials
- Existing S3 bucket (For Remote State Files) and DynamoDB table (For State Locking). DynamoDB must have a partition key called `LockID` with type `string`. Remember to update these names at root module's `main.tf` file.

### Modules

This project is divided into modules, where each subsystem has its own. For example:

- `indexing-subsystem`
- `peer-subsystem`
- `publishing-subsystem`

There are also modules with smaller scope for grouping resources that serve a specific purpose. For example: `api-gateway-to-s3`.

#### Module Dependency Tree

```
Root
└─── indexing-subsystem
│   └─── api-gateway-to-s3
