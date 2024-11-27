pipeline {
    agent any
    stages {
        stage('Checkout From Git') {
            steps {
                git branch: 'prod' , url: 'https://github.com/githubkusumam/terraform-aws.git'
            }
        }
    }
    stages {
        stage('Terraform Version') {
            steps {
                script {
                    sh 'terraform version'
                }
            }
        }
    }
}