pipeline {
    agent any

    environment {
        // GitHub credential ID (PAT)
        GIT_CRED_ID = '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'

        // CORRECT JWT Key Credential ID (file credential)
        JWT_CRED = 'a65c05f4-dc7c-43d8-8eb3-fb0af623694b'

        // Salesforce usernames
        SOURCE_USERNAME = 'rinkeshrayewar702-lbqp@force.com'
        TARGET_USERNAME = 'rinkeshrayewar702-tjzu@force.com'

        // Consumer Keys
        SOURCE_CLIENT_ID = '3MVG9GBhY6wQjl2vqGlWpTteyC4HbvVQqf1DJhsDIgM.knlqlQUGNmGP1qayR4sg1TzlwdAy84YXAUZMm2dNf'
        TARGET_CLIENT_ID = '3MVG9GBhY6wQjl2uu8JnhHsUEFpJYO3m7O9Zb4KG6Y8W.3G9dvxGNN0ppMbNrRW2OYVx2rWampchkPPxYLgnY'

        JOB_FILE = 'build.yaml'
    }

    stages {

        /* ---------------------
         CHECKOUT CODE
        ----------------------*/
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

        /* ---------------------
         AUTH: SOURCE ORG
        ----------------------*/
        stage('Authenticate Source Org') {
            steps {
                withCredentials([file(credentialsId: env.JWT_CRED, variable: 'JWT_FILE')]) {
                    bat """
                        sf org login jwt ^
                        --username "${SOURCE_USERNAME}" ^
                        --client-id "${SOURCE_CLIENT_ID}" ^
                        --jwt-key-file "${JWT_FILE}" ^
                        --instance-url https://login.salesforce.com
                    """
                }
            }
        }

        /* ---------------------
         EXPORT FROM SOURCE
        ----------------------*/
        stage('Export From Source Org') {
            steps {
                bat """
                    vlocity packExport -sfdx.username "${SOURCE_USERNAME}" -job "${JOB_FILE}"
                """
            }
        }

        /* ---------------------
         COMMIT CHANGES
        ----------------------*/
        stage('Commit Changes to Git') {
            steps {
                bat 'git status --porcelain > changes.txt'

                script {
                    def changes = readFile('changes.txt').trim()
                    if (changes) {
                        bat """
                            git add .
                            git commit -m "Automated DataPack Export from Jenkins"
                            git push origin main
                        """
                    } else {
                        echo "No changes. Skipping Git commit."
                    }
                }
            }
        }

        /* ---------------------
         AUTH: TARGET ORG
        ----------------------*/
        stage('Authenticate Target Org') {
            steps {
                withCredentials([file(credentialsId: env.JWT_CRED, variable: 'JWT_FILE')]) {
                    bat """
                        sf org login jwt ^
                        --username "${TARGET_USERNAME}" ^
                        --client-id "${TARGET_CLIENT_ID}" ^
                        --jwt-key-file "${JWT_FILE}" ^
                        --instance-url https://login.salesforce.com
                    """
                }
            }
        }

        /* ---------------------
         DEPLOY TO TARGET
        ----------------------*/
        stage('Deploy To Target Org') {
            steps {
                bat """
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
            echo "❌ Pipeline Failed — check Jenkins logs"
        }
    }
}
