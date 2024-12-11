pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'localhost:5000'
        PROJECT_NAME = 'main'
        GIT_REPO = 'https://github.com/justsearch78/NX-DEV.git'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }
        
        stage('Prepare Build Environment') {
            steps {
                sh '''
                mkdir -p build
                which cmake || sudo dnf install -y cmake
                which gcc || sudo dnf install -y gcc-c++
                '''
            }
        }
        
        stage('Build') {
            steps {
                sh '''
                cd build
                cmake ..
                cmake --build .
                '''
            }
        }
        
        stage('Test') {
            steps {
                sh '''
                cd build
                ./hello_world
                '''
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    def dockerImage = docker.build("${DOCKER_REGISTRY}/${PROJECT_NAME}:${BUILD_NUMBER}")
                }
            }
        }
        
        stage('Push to Registry') {
            steps {
                script {
                    docker.withRegistry('http://localhost:5000') {
                        docker.image("${DOCKER_REGISTRY}/${PROJECT_NAME}:${BUILD_NUMBER}").push()
                        docker.image("${DOCKER_REGISTRY}/${PROJECT_NAME}:${BUILD_NUMBER}").push('latest')
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBE_CONFIG')]) {
                    sh """
                    sed -i 's|image: localhost:5000/main:latest|image: ${DOCKER_REGISTRY}/${PROJECT_NAME}:${BUILD_NUMBER}|g' deploy/deployment.yaml
                    
                    kubectl --kubeconfig=${KUBE_CONFIG} apply -f deploy/
                    kubectl --kubeconfig=${KUBE_CONFIG} rollout status deployment/${PROJECT_NAME}
                    """
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}

