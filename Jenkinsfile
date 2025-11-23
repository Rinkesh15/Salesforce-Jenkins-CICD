pipeline {
    agent any

    environment {
        // GitHub credential ID
        GIT_CRED_ID = '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'

        // JWT secret file credential ID
        JWT_KEY = 'jwt_key'

        // Salesforce usernames for JWT auth
        SOURCE_USERNAME = 'rinkeshrayewar702-lbqp@force.com'
        TARGET_USERNAME = 'rinkeshrayewar702-tjzu@force.com'

        // Connected App Consumer Keys
        SOURCE_CLIENT_ID = '3MVG9GBhY6wQjl2vqGlWpTteyC4HbvVQqf1DJhsDIgM.knlqlQUGNmGP1qayR4sg1TzlwdAy84YXAUZMm2dNf'
        TARGET_CLIENT_ID = '3MVG9GBhY6wQjl2uu8JnhHsUEFpJYO3m7O9Zb4KG6Y8W.3G9dvxGNN0ppMbNrRW2OYVx2rWampchkPPxYLgnY'

        // Build Tool job file
        JOB_FILE = 'build.yaml'
    }

    stages {

        /* ---------------------------
         CHECKOUT CODE
        ----------------------------*/
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

        /* ---------------------------
         AUTH SOURCE ORG
        ----------------------------*/
        stage('Authenticate Source Org') {
            steps {
                withCredentials([file(credentialsId: env.JWT_KEY, variable: 'KEY_FILE')]) {
                    bat '''
                        echo Authenticating to Source Org...
                        sf org login jwt ^
                        --username "%SOURCE_USERNAME%" ^
                        --client-id "%SOURCE_CLIENT_ID%" ^
                        --jwt-key-file "%KEY_FILE%" ^
                        --instance-url https://login.salesforce.com
                    '''
                }
            }
        }

        /* ---------------------------
         PACK EXPORT
        ----------------------------*/
        stage('Export From Source Org') {
            steps {
                bat '''
                    echo Running packExport from Source Org...
                    vlocity packExport -sfdx.username "%SOURCE_USERNAME%" -job "%JOB_FILE%"
                '''
            }
        }

        /* ---------------------------
         GIT COMMIT CHANGES
        ----------------------------*/
        stage('Commit Changes to Git (If Any)') {
            steps {
                bat 'git status --porcelain > changes.txt'

                script {
                    def changes = readFile('changes.txt').trim()
                    if (changes) {
                        echo "Changes detected → committing to Git..."

                        bat '''
                            git add .
                            git commit -m "Automated DataPack Export from Jenkins"
                            git push origin main
                        '''
                    } else {
                        echo "No datapack changes → skipping commit."
                    }
                }
            }
        }

        /* ---------------------------
         AUTH TARGET ORG
        ----------------------------*/
        stage('Authenticate Target Org') {
            steps {
                withCredentials([file(credentialsId: env.JWT_KEY, variable: 'KEY_FILE')]) {
                    bat '''
                        echo Authenticating to Target Org...
                        sf org login jwt ^
                        --username "%TARGET_USERNAME%" ^
                        --client-id "%TARGET_CLIENT_ID%" ^
                        --jwt-key-file "%KEY_FILE%" ^
                        --instance-url https://login.salesforce.com
                    '''
                }
            }
        }

        /* ---------------------------
         PACK DEPLOY
        ----------------------------*/
        stage('Deploy to Target Org') {
            steps {
                bat '''
                    echo Deploying to Target Org...
                    vlocity packDeploy -sfdx.username "%TARGET_USERNAME%" -job "%JOB_FILE%"
                '''
            }
        }
    }

    post {
        success {
            echo "🚀 Deployment Completed Successfully!"
        }
        failure {
            echo "❌ Pipeline Failed — check Jenkins console log."
        }
    }
}
