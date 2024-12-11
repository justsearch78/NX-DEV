pipeline {
    agent {
        docker {
            image 'ubuntu:22.04'
            args '-u root'
        }
    }

    environment {
        CONAN_USER_HOME = "${WORKSPACE}"
    }

    stages {
        stage('Prepare') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y build-essential cmake python3-pip git wget
                    pip3 install conan
                '''
            }
        }

        stage('Dependency Install') {
            steps {
                sh '''
                    conan profile detect
                    conan install . --output-folder=build --build=missing
                '''
            }
        }

        stage('Build') {
            steps {
                sh '''
                    cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake
                    cmake --build build --config Release
                '''
            }
        }

        stage('Test') {
            steps {
                sh 'cd build && ctest --output-on-failure'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    docker.build('my-cpp-project:${BUILD_NUMBER}')
                }
            }
        }
    }

    post {
        always {
            junit 'build/test_results/*.xml'
            archiveArtifacts 'build/bin/*'
        }
    }
}
