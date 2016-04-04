# DemoBuilder

![CentOS Logo](logos/centos-logo-light.png)

The DemoBuilder is a series of hardware references, scripts, playbooks, and canned presentations
designed to make it easy for community managers and members to showcase the
best their project has to offer.

This repository will provide:

* Hardware specs and configurations
* Baseline images for easy provisioning
* Ansible playbooks for simple setup of various project demos
* Key points and features to showcase for each project


Participating projects:

* [gluster](https://www.gluster.org/)
* [rdo](https://www.rdoproject.org/)

## Getting Started

Production Requirements:
* SD Card Writer

Development Requirements:
* A working Vagrant install
* awscli
* Ansible v2.0 (On EL7 install from epel-testing)

Generating an ssh key to deploy to the cluster:
'''
ssh-keygen -f /path/to/demobuild/ansible/roles/base/files/ansible-id-rsa
'''

For development purposes, a Vagrantfile is provided to simulate the multi-node
environment. 

Below are setup steps for deploying a development cluster

### Vagrant: The AWS Provisioner
1. Set up a VPC and credentials for EC2

1. Configure the awscli tools with the appropriate credentials, the correct
   region, and the subnetid of your VPC
```
#~/.aws/config
[default]
output = json
region = <your_favorite_aws_region>

[vagrant]
subnet = <your_aws_subnet_id>
```
```
#~/.aws/credentials
[default]
aws_access_key_id = <your_aws_credential_id>
aws_secret_access_key = <your_aws_credential_secret>
```

1. Generate a new keypair in AWS and place the secret key in the root of the
   demobuild project named `aws.pem`

1. `vagrant up` will provision the VMs and run the playbooks for the default
   scenario

**NOTE:** Be sure you `vagrant destroy` when you're finished to avoid an extra
bill. 
