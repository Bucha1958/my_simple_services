pipeline {
    agent any

    environment {
        GIT_URL = 'https://github.com/Bucha1958/my_simple_services.git'
        BACKEND_DIR = 'nodebackend'
        FRONTEND_DIR = 'frontend'
        GIT_CREDENTIALS = 'github-credentials'
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'
        VERSION_TAG = "${BUILD_NUMBER}-${GIT_COMMIT[0..6]}"
        KUBECONFIG_CREDENTIALS_ID = 'kubernetes-credentials'
        KUBECONFIG_PATH = '/home/jenkins/.kube/config'
        PATH = "/var/jenkins_home/google-cloud-sdk/bin:${PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${GIT_CREDENTIALS}", passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    git credentialsId: "${GIT_CREDENTIALS}", url: GIT_URL
                }
                // Add echo to check GIT_COMMIT and VERSION_TAG
                script {
                    echo "GIT_COMMIT: ${GIT_COMMIT}"
                    echo "VERSION_TAG: ${VERSION_TAG}"
                }
            }
        }

        // stage('Install Backend Dependencies') {
        //     steps {
        //         dir("${BACKEND_DIR}") {
        //             script {
        //                 echo 'Installing Backend Dependencies...'
        //                 sh 'echo $PATH'
        //                 sh 'npm install || (echo "npm install failed" && exit 1)'
        //             }
        //         }
        //     }
        // }
        

        stage('Deploy Frontend') {
            steps {
                dir("${FRONTEND_DIR}") {
                    script {
                        echo 'Frontend is static, no build required.'
                    }
                }
            }
        }

        // stage('Build and Push nodeBackend Docker Image') {
        //     steps {
        //         script {
        //             withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
        //                 dir('nodebackend') {
        //                     echo "Building backend Docker image..."
        //                     sh 'docker build -t bucha1958/nodebackend-service:${VERSION_TAG} .'
                            
        //                     echo "Logging in to DockerHub..."
        //                     sh 'echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin'
                            
        //                     echo "Pushing backend Docker image..."
        //                     sh "docker tag bucha1958/nodebackend-service:${VERSION_TAG} bucha1958/nodebackend-service:latest"
        //                     sh "docker push bucha1958/nodebackend-service:latest"
        //                 }
        //             }
        //         }
        //     }
        // }

        stage('Build JAR') {
            steps {
                script {
                        dir('MyFristDemoWithSpring/MyFristDemoWithSpring') {
                            sh 'mvn clean package'
                        }
                }
            }
        }

        stage('Build and Push MyFirstDemoWithSpring Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                        dir('MyFristDemoWithSpring') {
                            echo "Building backend Docker image..."
                            // Ensure the target folder is present
                            sh 'ls -al MyFristDemoWithSpring/target/'
                            
                            sh 'docker build -t bucha1958/my_java_app:latest .'
                            
                            echo "Logging in to DockerHub..."
                            sh 'echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin'
                            
                            echo "Pushing backend Docker image..."
                            sh "docker tag bucha1958/my_java_app:latest bucha1958/my_java_app:latest"
                            sh "docker push bucha1958/my_java_app:latest"
                        }
                    }
                }
            }
        }

        stage('Build and Push Frontend Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                        dir('frontend') {
                            echo "Building frontend Docker image..."
                            sh 'docker build -t bucha1958/frontend-service:${VERSION_TAG} .'
                            
                            echo "Logging in to DockerHub..."
                            sh 'echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin'
                            
                            echo "Pushing frontend Docker image..."
                            sh "docker tag bucha1958/frontend-service:${VERSION_TAG} bucha1958/frontend-service:latest"
                            sh "docker push bucha1958/frontend-service:latest"
                        }
                    }
                }
            }
        }

        stage('Build and Push Nginx Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                        dir('custome_nginx') {
                            echo "Building custome_nginx Docker image..."
                            sh 'docker build -t bucha1958/nginx:latest .'
                            
                            echo "Logging in to DockerHub..."
                            sh 'echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin'
                            
                            echo "Pushing nginx Docker image..."
                            sh "docker tag bucha1958/nginx:latest bucha1958/nginx:latest"
                            sh "docker push bucha1958/nginx:latest"
                        }
                    }
                }
            }
        }

         stage('Deploy to GKE') {
            steps {
                script {
                    echo "Checking if namespace 'microservices' exists..."
                    def nsExists = sh(script: "kubectl get ns microservices --ignore-not-found", returnStatus: true) == 0
                    
                    if (!nsExists) {
                        echo "Namespace 'microservices' does not exist. Creating it..."
                        sh 'kubectl create namespace microservices'
                        // Add a brief delay to ensure the namespace is fully registered
                        sleep 5
                        sh 'kubectl get ns microservices'
                    } else {
                        echo "Namespace 'microservices' already exists."
                    }

                    echo "Deploying to GKE..."
                    sh '''
                        kubectl apply -f config.yaml -n microservices
                        kubectl apply -f custome_nginx/nginxConfig.yaml -n microservices
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace'
            cleanWs()
        }
        success {
            echo 'Build and tests succeeded!'
        }
        failure {
            echo 'Build or tests failed!'
        }
    }
}
