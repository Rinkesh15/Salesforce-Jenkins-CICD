pipeline {
    agent any

    environment {
        SOURCE_ORG = "rinkeshrayewar702-lbqp@force.com"
        TARGET_ORG = "rinkeshrayewar702-tjzu@force.com"

        CLIENT_ID_SOURCE = "3MVG9GBhY6wQjl2vqGlWpTteyC4HbvVQqf1DJhsDIgM.knlqlQUGNmGP1qayR4sg1TzlwdAy84YXAUZMm2dNf"
        CLIENT_ID_TARGET = "3MVG9GBhY6wQjl2uu8JnhHsUEFpJYO3m7O9Zb4KG6Y8W.3G9dvxGNN0ppMbNrRW2OYVx2rWampchkPPxYLgnY"
    }

    stages {

        stage('Authenticate Source Org') {
            steps {
                withCredentials([file(credentialsId: 'a65c05f4-dc7c-43d8-8eb3-fb0af623694b', variable: 'JWT_KEY')]) {
                    bat """
                    sf org login jwt --username "${SOURCE_ORG}" --client-id "${CLIENT_ID_SOURCE}" --jwt-key-file "${JWT_KEY}"
                    """
                }
            }
        }

        stage('Authenticate Target Org') {
            steps {
                withCredentials([file(credentialsId: 'a65c05f4-dc7c-43d8-8eb3-fb0af623694b', variable: 'JWT_KEY')]) {
                    bat """
                    sf org login jwt --username "${TARGET_ORG}" --client-id "${CLIENT_ID_TARGET}" --jwt-key-file "${JWT_KEY}"
                    """
                }
            }
        }

        // Add remaining stages here after JWT works
    }
}
