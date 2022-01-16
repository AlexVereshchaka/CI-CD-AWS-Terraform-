pipeline {
    //set variables
  environment { 
    imagename = "yagorus/first_demo"
    //cred to access to docker hub 
    registryCredential = 'docker-hub-cred'
  }
  //agent == machina (nodes) | any == any all machine (nodes)
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git([url: 'git@github.com:Yagorus/TestWebDeploy.git', branch: 'main', credentialsId: 'github-ssh-key-demo'])
      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build imagename
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
             dockerImage.push('static')
          }
        }
      }
    }
    stage('ansible'){
        steps{
            script{
                ansible all -m shell -a "docker service update --image yagorus/first_demo:static first_demo"
            }
        }
    }
    
    }
  }