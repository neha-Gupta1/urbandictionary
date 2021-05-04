node{
    List myEnv = [
        "IBM_CLOUD_DEVOPS_ORG='5f078b80993e17992baf4c5a'",  // AC-Pub-1
        "IBM_CLOUD_DEVOPS_CREDS='51545393-74c7-42fa-89cf-1bb4f62d0209'",
        "IBM_CLOUD_DEVOPS_APP_NAME='dev'",
        "IBM_CLOUD_DEVOPS_TOOLCHAIN_ID='?'",
        "IBM_DASH_HOSTNAME='secops-core.multicloud-ibm.com/dash'"
        "IBM_CLOUD_DEVOPS_CREDS_USR='test12345'",
        "IBM_CLOUD_DEVOPS_CREDS_PSW='>>??'"
        
    ]
    
    // ------------------------------------
    //  withCredentials([usernamePassword(credentialsId: '51545393-74c7-42fa-89cf-1bb4f62d0209', 
    //             passwordVariable: 'IBM_CLOUD_DEVOPS_CREDS_PSW', usernameVariable: 'IBM_CLOUD_DEVOPS_CREDS_USR')]) {
    //             stage('Build') {
    //                 dir ("${GOPATH}/src/github.ibm.com/dash/dash_build") {
    //                     def gitCommit = sh(returnStdout: true, script: "git rev-parse HEAD").trim()
    //                     withEnv(["GIT_COMMIT=${gitCommit}", 'GIT_BRANCH=master', 'GIT_REPO=https://github.ibm.com/dash/dash_build', 'DEVOPS_HOST=dev-dash.gravitant.net', 'SERVICE=dash_build']){      
    //                         try {
    //                             sh 'go build .' 

    //                             // use "publishBuildRecord" method to publish build record
    //                             publishBuildRecord gitBranch: "${GIT_BRANCH}", gitCommit: "${GIT_COMMIT}", gitRepo: "${GIT_REPO}", result:"SUCCESS", hostName: "${DEVOPS_HOST}", serviceName: "${SERVICE}"
    //                         }
    //                         catch (Exception e) {
    //                             publishBuildRecord gitBranch: "${GIT_BRANCH}", gitCommit: "${GIT_COMMIT}", gitRepo: "${GIT_REPO}", result:"FAIL", hostName: "${DEVOPS_HOST}", serviceName: "${SERVICE}"
    //                         }
    //                     }  
    //                 }
    //             }
    //         }
    // ------------------------------------
    
    
    
     withEnv(myEnv) {
    
    ws("${HOME}/agent/jobs/${JOB_NAME}/builds/${BUILD_ID}/") {  
        
         stage('Checkout') {
                
                    git(
                        url: 'https://github.com/Wizkaley/urbandictionary.git',
                        branch: "master"
                    )
                
            }
        withCredentials([usernamePassword(credentialsId: '6e2239d6-7cb9-42eb-b28c-f6c72395b460', 
                passwordVariable: 'IBM_CLOUD_DEVOPS_CREDS_PSW', usernameVariable: 'IBM_CLOUD_DEVOPS_CREDS_USR')]) {
                    stage('Unit Test and Code Coverage') {
                  
                    // use "publishTestResult" method to publish test result
//publishTestResult type:'unit', fileLocation: '/var/jenkins_home/workspace/Jenkins-Github/simpleTest.json'
                    publishTestResult fileLocation: './junit_report_tests_pass.xml', type: "unit", serviceName: "urbandictionary",  resultType: "junit"
                    //, credentialsId: '6e2239d6-7cb9-42eb-b28c-f6c72395b460'
                } 
                }
    }
}
}
