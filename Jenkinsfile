pipeline {
    agent any

    environment {
        // JWT key file credential
        JWT_CRED_ID = 'a65c05f4-dc7c-43d8-8eb3-fb0af623694b'

        // Salesforce usernames
        SOURCE_USERNAME = 'rinkeshrayewar702-lbqp@force.com'
        TARGET_USERNAME = 'rinkeshrayewar702-tjzu@force.com'

        // Connected App Consumer Keys
        SOURCE_CLIENT_ID = '3MVG9GBhY6wQjl2vqGlWpTteyC4HbvVQqf1DJhsDIgM.knlqlQUGNmGP1qayR4sg1TzlwdAy84YXAUZMm2dNf'
        TARGET_CLIENT_ID = '3MVG9GBhY6wQjl2uu8JnhHsUEFpJYO3m7O9Zb4KG6Y8W.3G9dvxGNN0ppMbNrRW2OYVx2rWampchkPPxYLgnY'
    }

    stages {

        /*------------------------------------
         CHECKOUT FROM jenkins-dev BRANCH
        ------------------------------------*/
        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/jenkins-dev']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Rinkesh15/Salesforce-Jenkins-CICD.git',
                        credentialsId: 'github_token'
                    ]]
                ])
            }
        }

        /*------------------------------------
         AUTHENTICATE TARGET ORG (JWT)
        ------------------------------------*/
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

        /*------------------------------------
         DEPLOY ONLY ONE APEX CLASS
        ------------------------------------*/
        stage('Deploy Apex Class') {
            steps {
                bat """
                    sf project deploy start ^
                    --source-dir force-app/main/default/classes/CICDJenkins.cls ^
                    --target-org ${TARGET_USERNAME} ^
                    --ignore-conflicts
                """
            }
        }
    }
}
