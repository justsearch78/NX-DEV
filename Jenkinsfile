pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                git branch: 'main', url: 'https://github.com/justsearch78/NX-DEV.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the C++ application using CMake...'
                sh '''
                mkdir -p build
                cd build
                cmake ..
                cmake --build .
                '''
            }
        }

        stage('Docker Build and Push') {
            steps {
                echo 'Building and pushing Docker image...'
                sh '''
                docker build -t main:latest .
                docker tag main:latest localhost:5000/main:latest

                # Push to local registry
                docker push localhost:5000/main:latest
                '''
            }
        }

        stage('Run Container') {
            steps {
                echo 'Running the Docker container...'
                sh '''
                # Stop and remove any existing container with the same name
                docker stop main || true
                docker rm main || true

                # Run the new container
                docker run -d -p 8080:80 --name main localhost:5000/main:latest
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
    }
}
