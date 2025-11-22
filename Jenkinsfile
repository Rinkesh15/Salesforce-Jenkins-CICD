pipeline {
    agent any

    environment {
        SOURCE_ORG = "rinkeshrayewar702-lbqp@force.com"
        TARGET_ORG = "rinkeshrayewar702-tjzu@force.com"

        CLIENT_ID_SOURCE = "3MVG9GBhY6wQjl2vqGlWpTteyC04k.XC5s7WKEQLN6MAlNtcFi20WVYNb4Dz7ubaLbNPIJ759UNi.6v7YtE9q"
        CLIENT_ID_TARGET = "3MVG9GBhY6wQjl2uu8JnhHsUEFiVjGk5UA1IfaGmhZORVwSGeq8_jDccvmInOakGcOmotRpi9TrEYkc.ycpHr"
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
