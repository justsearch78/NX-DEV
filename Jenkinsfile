pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://your-git-repo.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mkdir -p build && cd build && cmake .. && cmake --build .'
            }
        }
        stage('Test') {
            steps {
                sh 'cd build && ctest'
            }
        }
        stage('Docker Build') {
            steps {
                sh '''
                docker build -t my-cpp-app:latest .
                docker tag my-cpp-app:latest localhost:5000/my-cpp-app:latest
                docker push localhost:5000/my-cpp-app:latest
                '''
            }
        }
    }
}
