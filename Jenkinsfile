pipeline {
  agent {
    docker {
      // Docker中已经运行Jenkins容器，这里在运行Node容器
      // Node容器成为了Jenkins用来运行流水线项目的agent，这个容器寿命较短，只是流水线执行的持续时间
      image 'node:6-alpine'
      // 使得Node容器可以暂时的通过端口3000进行访问
      args '-p 3000:3000'
    }
  }
  stages {
    stage('Build') {
      steps {
        sh 'npm install'
      }
    }
  }
}