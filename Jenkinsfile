def ARTIFACTORY_URL = 'https://xorazn.jfrog.io/artifactory/'

pipeline {
    agent { label 'Linux' }
    // options {
    //     skipDefaultCheckout true
    // }
    tools {
        maven 'maven'
        jfrog 'jfrog-cli'
    }
    stages {
        // stage ('SCM') {
        //     steps {
        //        echo "---------SCM Start----------"
        //        git branch: 'temp', credentialsId: 'ayaz-github-creds', url: 'https://github.com/azdn949/maven-app.git'
        //        sh "ls -l"
        //        echo "---------SCM End------------"
        //     }
        // }
        stage ('Build') {
            steps {
               echo "---------Build Start----------"
               sh "mvn clean install -DskipTests"
               sh "ls -l target/"
               echo "---------Build End------------"
            }
        }
        stage ('Sonar Scan') {
            steps {
                echo "---------Sonar Scan Start----------"
                // withSonarQubeEnv('Sonarqube Server') {
                //     sh 'mvn sonar:sonar'
                    
                // } 
                // timeout(time: 2, unit: 'MINUTES') {
                //     // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                //     // true = set pipeline to UNSTABLE, false = don't
                //     waitForQualityGate abortPipeline: true
                // }
                echo "---------Sonar Scan End----------" 
            }
        }
        stage ('Artifactory') {
            steps {
                echo "---------------Artifactory Start---------"
                withCredentials([usernamePassword(credentialsId: 'jfrog-creds', passwordVariable: 'JFROG_PASSWORD', usernameVariable: 'JFROG_USER')]) {
                    jf "rt u  target/*.jar --flat=true xoriant-maven/${env.JOB_NAME}/${env.BUILD_NUMBER}/ --url ${ARTIFACTORY_URL} --user ${JFROG_USER} --password ${JFROG_PASSWORD}"
                    jf "rt u  pom.xml --flat=true xoriant-maven/${env.JOB_NAME}/${env.BUILD_NUMBER}/ --url ${ARTIFACTORY_URL} --user ${JFROG_USER} --password ${JFROG_PASSWORD}"
                } 
                echo "---------------Artifactory End----------" 
            }
        }
        stage ('Docker Image') {
            steps {
                echo "------------Docker Image Start------------"
                withCredentials([usernamePassword(credentialsId: 'jfrog-creds', passwordVariable: 'JFROG_PASSWORD', usernameVariable: 'JFROG_USER')]) {
                    sh "docker build -t xorazn.jfrog.io/xoriant-docker/${env.JOB_NAME}:${env.BUILD_NUMBER} ."
                    
                    sh "docker push xorazn.jfrog.io/xoriant-docker/${env.JOB_NAME}:${env.BUILD_NUMBER}"
                    sh "docker rmi -f xorazn.jfrog.io/xoriant-docker/${env.JOB_NAME}:${env.BUILD_NUMBER}"
                }
                echo "------------Docker Image End-----------" 
            }
        }
        stage ('Deployment') {
            steps {
                echo "------------Deployment Start------------"
                sh "kubectl apply -f kubernetes"
                echo "------------Deployment End------------"
            }
        }
        
    } // End of Stages
    // post { 
    //         cleanup { 
    //             echo "Clean up in post workspace"
    //             cleanWs()
    //         } // End of cleanup
    // }
} // End of Pipeline