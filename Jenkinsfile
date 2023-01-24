pipeline {
    agent any
    environment {
	SSHKEY=credentials('sshkey')
	}
    triggers {
      pollSCM '* * * * *'
	}
    stages {
        stage("Build") {
            steps {
                echo "--- Build ---"
                sh "docker build -t dajoker123/$JOB_NAME:v$BUILD_ID ."
            }
        }
        stage("Push") {
            steps {
                echo "--- Push ---"
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'pass', usernameVariable: 'user')]) {
                sh "docker login -u $user -p $pass"
                sh "docker push dajoker123/$JOB_NAME:v$BUILD_ID"
                }
            }
        }
        stage("Deploy") {
            steps {
		withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'password', usernameVariable: 'username')]) {
                echo "--- Deploy ---"
                sh "ansible-playbook playbook.yaml -i inventory --private-key=$SSHKEY -u ansible --become -e username=$username -e password=$password -e BUILD_ID=$BUILD_ID "
		}
            }
        }
    }
}
