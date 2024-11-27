pipeline {
    agent any
    stages {
        stage('Checkout From Git') {
            steps {
                git branch: 'prod' , url: 'https://github.com/githubkusumam/terraform-aws.git'
            }
        }
        stage('Terraform Version') {
            steps {
                script {
                    sh 'terraform version'
                }
            }
        }
        stage('Terraform init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform validate') {
            steps {
                script {
                    sh 'terraform validate'
                }
            }
        }
        stage('Terraform plan') {
            steps {
                script {
                    sh 'terraform plan'
                }
            }
        }
        stage('Terraform apply') {
            steps {
                script {
                    sh 'terraform apply --auto-approve'
                }
            }
        }
        stage('Approve To Destroy') {
            steps {
                input message: 'Approve to Destroy', ok: 'Destroy'
            }
        }
        stage('Terraform Destroy') {
            steps {
                script {
                    sh 'terraform destroy --auto-approve'
                }
            }
        }
    }
}