pipeline {
    agent any

    environment {
        JWT_CRED_ID = 'a65c05f4-dc7c-43d8-8eb3-fb0af623694b'
        GIT_CRED_ID = 'github_token'

        SOURCE_USERNAME = 'rinkeshrayewar702-lbqp@force.com'
        TARGET_USERNAME = 'rinkeshrayewar702-tjzu@force.com'

        SOURCE_CLIENT_ID = '3MVG9GBhY6wQjl2vqGlWpTteyC4HbvVQqf1DJhsDIgM.knlqlQUGNmGP1qayR4sg1TzlwdAy84YXAUZMm2dNf'
        TARGET_CLIENT_ID = '3MVG9GBhY6wQjl2uu8JnhHsUEFpJYO3m7O9Zb4KG6Y8W.3G9dvxGNN0ppMbNrRW2OYVx2rWampchkPPxYLgnY'

        JOB_FILE = 'build.yaml'
    }

    stages {

        /*----------------------------------
          ONLY ONE CHECKOUT (IMPORTANT)
        ----------------------------------*/
        stage('Checkout Code') {
    steps {
        checkout([
            $class: 'GitSCM',
            branches: [[name: 'jenkins-dev']],
            doGenerateSubmoduleConfigurations: false,
            extensions: [[$class: 'LocalBranch']],   // IMPORTANT: creates real local branch
            userRemoteConfigs: [[
                url: 'https://github.com/Rinkesh15/Salesforce-Jenkins-CICD.git',
                credentialsId: 'github_token'
            ]]
        ])
    }
}

        /*----------------------------------
          AUTH SOURCE ORG
        ----------------------------------*/
        stage('Auth Source Org') {
            steps {
                withCredentials([file(credentialsId: env.JWT_CRED_ID, variable: 'JWT_FILE')]) {
                    bat """
                        sf org login jwt ^
                        --username "${SOURCE_USERNAME}" ^
                        --client-id "${SOURCE_CLIENT_ID}" ^
                        --jwt-key-file "${JWT_FILE}"
                    """
                }
            }
        }

        /*----------------------------------
          EXPORT
        ----------------------------------*/
        stage('Export OmniStudio Data') {
            steps {
                bat """
                    vlocity packExport -sfdx.username "${SOURCE_USERNAME}" -job "${JOB_FILE}"
                """
            }
        }

        /*----------------------------------
          COMMIT + PUSH
        ----------------------------------*/
        stage('Commit & Push Changes') {
            steps {
                bat '''
                    git config --global user.email "jenkins@cicd.com"
                    git config --global user.name "Jenkins CI Bot"
                '''

                bat 'git status --porcelain > changes.txt'

                script {
                    def changes = readFile('changes.txt').trim()

                    if (changes) {
                        echo "Changes detected → committing..."

                        bat '''
                            git add .
                            git commit -m "Automated Export from Jenkins"
                            git push origin jenkins-dev
                        '''
                    } else {
                        echo "No changes found → skipping commit."
                    }
                }
            }
        }

        /*----------------------------------
          AUTH TARGET ORG
        ----------------------------------*/
        stage('Auth Target Org') {
            steps {
                withCredentials([file(credentialsId: env.JWT_CRED_ID, variable: 'JWT_FILE')]) {
                    bat """
                        sf org login jwt ^
                        --username "${TARGET_USERNAME}" ^
                        --client-id "${TARGET_CLIENT_ID}" ^
                        --jwt-key-file "${JWT_FILE}"
                    """
                }
            }
        }

        /*----------------------------------
          DEPLOY
        ----------------------------------*/
        stage('Deploy CICDJenkins.cls') {
            steps {
                bat """
                    sf project deploy start ^
                    --source-dir force-app/main/default/classes/CICDJenkins.cls ^
                    --target-org "${TARGET_USERNAME}" ^
                    --ignore-conflicts
                """
            }
        }
    }

    post {
        success { echo "SUCCESS" }
        failure { echo "FAILED" }
    }
}
