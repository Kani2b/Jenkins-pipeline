pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t my-flask .'
                sh 'docker tag my-flask $DOCKER_BFLASK_IMAGE'
            }
        }
        
        stage('Test') {
            steps {
                sh 'docker run my-flask python -m pytest app/tests/'
            }
        } 
        
        stage('Deploy') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_REGISTRY_CREDS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin docker.io"
                    sh 'docker push $DOCKER_BFLASK_IMAGE'
                }
            }
        }
    }

    post {
        success {
            // Send email on successful build
            emailext body: "Job Name: ${env.JOB_NAME} || Build Number: ${env.BUILD_NUMBER}\n Build Status: SUCCESS\n More information at: ${env.BUILD_URL}",
                subject: 'Successful Build Notification',
                to: 'kanithanf@gmail.com'
        }
        failure {
            // Send email on build failure
            emailext body: "Job Name: ${env.JOB_NAME} || Build Number: ${env.BUILD_NUMBER}\n Build Status: FAILURE\n More information at: ${env.BUILD_URL}",
                subject: 'Failed Build Notification',
                to: 'kanithanf@gmail.com'
        }
        always {
            // Cleanup steps
            sh 'docker rm -f mypycont'
            sh 'docker run --name mypycont -d -p 3000:5000 my-flask'
        }
    }
}
