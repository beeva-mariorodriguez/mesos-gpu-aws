# PoC Mesos cluster with GPU support

experiment: build a Mesos cluster in AWS with nvidia GPU support

## notes
* this is an experiment/proof of concept, do NOT use blindly in production

## requiremente
* [packer](https://www.packer.io/)
* [terraform](https://www.terraform.io/)

## instructions

0. authenticate with aws and export the three variables:

1. build the AMI: https://github.com/beeva-mariorodriguez/beevalabs-k8s-gpu-ami
    ```sh
    vi beevalabs-k8s-1.6-gpu-jessie.json # change the AMI name!
    packer build beevalabs-k8s-1.6-gpu-jessie.json
    ```

2. export terraform environment variables
    ```sh
    export TF_VAR_cluster_name="mesoscluster"
    export TF_VAR_aws_region="us-east-2"
    export TF_VAR_aws_cidr_block="10.20.0.0/16"
    export TF_VAR_aws_ami_gpu="ami-a123456" # your ami w/ nvidia drivers and CUDA
    export TF_VAR_aws_key_name="mesoskey" # ssh key name at aws
    ```

4. deploy!
    ```sh
    terraform plan
    terraform apply
    ```

## references
* http://www.agiletrailblazers.com/blog/4-step-application-deployment-in-aws-using-apache-mesos-and-marathon
* https://mesos.apache.org/documentation/latest/gpu-support/
* https://mesos.apache.org/documentation/latest/architecture/

