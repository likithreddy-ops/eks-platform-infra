This repo provisions the AWS infrastructure for a self-directed platform engineering project: a multi-AZ VPC (public/private subnets, NAT Gateway, VPC Flow Logs), an EKS cluster with KMS-encrypted Kubernetes Secrets, control plane logging, and a managed node group — all defined as Terraform, using the community terraform-aws-modules for VPC and EKS.

Built with cost-consciousness in mind (single shared NAT Gateway, small instance types) since this is a self-funded personal project — enterprise-scale tradeoffs (per-AZ NAT, bastion host access, modular restructuring) are documented as intentional deferrals, not oversights.

The Kubernetes application layer (a 5-service microservices voting app, deployed via GitOps) lives in a companion repo: [link to eks-platform-manifests or your chosen name].
