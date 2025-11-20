pipeline { 
    agent any 
    environment { 
        SOURCE_ORG = "rinkeshrayewar702-lbqp@force.com" 
        CLIENT_ID_SOURCE = "3MVG9GBhY6wQjl2vqGlWpTteyC4HbvVQqf1DJhsDIgM.knlqlQUGNmGP1qayR4sg1TzlwdAy84YXAUZMm2dNf" 
        TARGET_ORG = "rinkeshrayewar702-tjzu@force.com" 
        CLIENT_ID_TARGET = "3MVG9GBhY6wQjl2uu8JnhHsUEFpJYO3m7O9Zb4KG6Y8W.3G9dvxGNN0ppMbNrRW2OYVx2rWampchkPPxYLgnY" 
        JWT_KEY = "C:\\Jenkins\\jwt\\server.key" 
    } 
    stages { 
        stage('Checkout Code') { 
            steps { 
                git branch: 'main', 
                url: 'https://github.com/Rinkesh15/repoForJenkins' 
            } 
        } 
        stage('Authorize Source Org') { 
            steps { 
                bat "sf org login jwt --username %%SOURCE_ORG%% --client-id %%CLIENT_ID_SOURCE%% --jwt-key-file %%JWT_KEY%%" 
            } 
        } 
        stage('Authorize Target Org') { 
            steps { 
                bat "sf org login jwt --username %%TARGET_ORG%% --client-id %%CLIENT_ID_TARGET%% --jwt-key-file %%JWT_KEY%%" 
            } 
        } 
        stage('Deploy Apex and LWC') { 
            steps { 
                bat "sf project deploy start --source-dir force-app --target-org %%TARGET_ORG%%" 
            } 
        } 
        stage('Deploy OmniStudio') { 
            steps { 
                bat "vlocity packDeploy -sfdx.username %%TARGET_ORG%% -job vlocity\\build.json" 
            } 
        } 
    } 
} 
