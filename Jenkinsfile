def ARTIFACTORY_URL = 'https://xorazn.jfrog.io/artifactory/'
def JFROGDOCKER_URL = 'xorazn.jfrog.io'

pipeline {
    agent {
        label 'Linux'
    }
    //options {
     // skipDefaultCheckout true
    //}
    tools {
      maven 'Maven_Home'
      jfrog 'jfrog-cli'
    }
    stages {
    //    stage ('------SCM START------') {
      //      steps {
        //       git branch: 'feature/APP-1', credentialsId: 'tapaswini-github-creds', url: 'https://github.com/tapaswsa/maven-app-project.git'
          //     echo "------- SCM STOP ------"
           // }
        //}
        stage ('Build') {
            steps {
               echo "Build start"
               sh "mvn clean install -DskipTests"
               sh "ls -ltr target"
            }
        }
        stage ('Sonar Scan') {
            steps {
                echo "Sonar Scan"
                withSonarQubeEnv('Sonarqube Server') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        stage ('Artifactory') {
            steps {
                echo "Push Artifacts to Jfrog Artifactory"
                
                withCredentials([usernamePassword(credentialsId: 'Jfrog-ayaz-creds', passwordVariable: 'MYPASSWORD', usernameVariable: 'MYUSER')]) {
                    jf "rt u  target/*.jar --flat=true tapu-maven/${env.JOB_NAME}/${env.BUILD_NUMBER}/ --url ${ARTIFACTORY_URL} --user ${MYUSER} --password ${MYPASSWORD}"
                    jf "rt u  pom.xml --flat=true tapu-maven/${env.JOB_NAME}/${env.BUILD_NUMBER}/ --url ${ARTIFACTORY_URL} --user ${MYUSER} --password ${MYPASSWORD}"
                }    
            }
        }
        stage ('Docker Image') {
            steps {
                echo "Upload Docker Image to Jfrog Artifactory"
                 withCredentials([usernamePassword(credentialsId: 'Jfrog-ayaz-creds', passwordVariable: 'MYPASSWORD', usernameVariable: 'MYUSER')]) {
                     sh "docker build -t ${JFROGDOCKER_URL}/tapu-docker/${env.JOB_NAME}:${env.BUILD_NUMBER} ."
                     sh "docker login ${JFROGDOCKER_URL} -u ${MYUSER} -p ${MYPASSWORD}"
                     sh "docker push ${JFROGDOCKER_URL}/tapu-docker/${env.JOB_NAME}:${env.BUILD_NUMBER}"
                     sh "docker rmi -f ${JFROGDOCKER_URL}/tapu-docker/${env.JOB_NAME}:${env.BUILD_NUMBER}"
                }    
                
            }
        }
        stage ('Deployment') {
            steps {
                echo "Deployment" 
            }
        }
    }
}   
