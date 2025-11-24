pipeline {
    agent any

    environment {

        // GitHub Token Credential ID (you MUST use the correct one)
        GIT_CRED_ID = 'github_token'

        // JWT Key File Credential ID (THIS IS THE ONLY CORRECT ONE)
        JWT_CRED_ID = 'a65c05f4-dc7c-43d8-8eb3-fb0af623694b'

        // Salesforce usernames
        SOURCE_USERNAME = 'rinkeshrayewar702-lbqp@force.com'
        TARGET_USERNAME = 'rinkeshrayewar702-tjzu@force.com'

        // Connected App Consumer Keys
        SOURCE_CLIENT_ID = '3MVG9GBhY6wQjl2vqGlWpTteyC4HbvVQqf1DJhsDIgM.knlqlQUGNmGP1qayR4sg1TzlwdAy84YXAUZMm2dNf'
        TARGET_CLIENT_ID = '3MVG9GBhY6wQjl2uu8JnhHsUEFpJYO3m7O9Zb4KG6Y8W.3G9dvxGNN0ppMbNrRW2OYVx2rWampchkPPxYLgnY'

        // Build Tool job file
        JOB_FILE = 'build.yaml'
    }

    stages {

        /*------------------------------------
         CHECKOUT PROJECT
        -------------------------------------*/
        stage('Checkout Source Code') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Rinkesh15/Salesforce-Jenkins-CICD.git',
                        credentialsId: env.GIT_CRED_ID
                    ]]
                ])
            }
        }


        /*------------------------------------
         AUTHENTICATE SOURCE ORG (JWT)
        -------------------------------------*/
        stage('Authenticate Source Org') {
            steps {
                withCredentials([file(credentialsId: env.JWT_CRED_ID, variable: 'JWT_FILE')]) {
                    bat """
                        echo Authenticating to Source Org...
                        sf org login jwt ^
                        --username "${SOURCE_USERNAME}" ^
                        --client-id "${SOURCE_CLIENT_ID}" ^
                        --jwt-key-file "${JWT_FILE}" ^
                        --instance-url https://login.salesforce.com
                    """
                }
            }
        }

        /*------------------------------------
         EXPORT FROM SOURCE ORG
        -------------------------------------*/
        stage('Export From Source Org') {
            steps {
                bat """
                    echo Running Vlocity Export...
                    vlocity packExport -sfdx.username "${SOURCE_USERNAME}" -job "${JOB_FILE}"
                """
            }
        }

        /*------------------------------------
         COMMIT + PUSH TO GIT
        -------------------------------------*/
        stage('Commit Changes to Git') {
            steps {

                // FIX 1: Set Git identity (critical)
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
                            git commit -m "Automated DataPack Export from Jenkins"
                            git push origin main
                        '''
                    } else {
                        echo "No changes found → skipping Git commit."
                    }
                }
            }
        }

        /*------------------------------------
         AUTHENTICATE TARGET ORG
        -------------------------------------*/
        stage('Authenticate Target Org') {
            steps {
                withCredentials([file(credentialsId: env.JWT_CRED_ID, variable: 'JWT_FILE')]) {
                    bat """
                        echo Authenticating to Target Org...
                        sf org login jwt ^
                        --username "${TARGET_USERNAME}" ^
                        --client-id "${TARGET_CLIENT_ID}" ^
                        --jwt-key-file "${JWT_FILE}" ^
                        --instance-url https://login.salesforce.com
                    """
                }
            }
        }

        /*------------------------------------
         DEPLOY TO TARGET ORG
        -------------------------------------*/
        stage('Deploy To Target Org') {
            steps {
                bat """
                    echo Deploying DataPacks to Target Org...
                    vlocity packDeploy -sfdx.username "${TARGET_USERNAME}" -job "${JOB_FILE}"
                """
            }
        }
    }

    post {
        success {
            echo "🚀 Deployment Completed Successfully!"
        }
        failure {
            echo "❌ Pipeline Failed — please check Jenkins console logs."
        }
    }
}
