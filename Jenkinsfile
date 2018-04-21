node {
    dir("/root/"){
    	checkout scm

    	env.DOCKER_API_VERSION="1.23"
    	appName = "default/iib10app"
    	registryHost = "mycluster.icp:8500/"
	deploymentName = "iib10-ibm-integration-bu"
    	imageName = "${registryHost}${appName}:${env.BUILD_ID}"

    	env.BUILDIMG=imageName

    	docker.withRegistry("https://mycluster.icp:8500/", "docker"){
    		stage "Build"

        	def pcImg = docker.build("${imageName}", "-f Dockerfile .")
		pcImg.tag()
        	pcImg.push()

    		input 'Do you want to proceed with Deployment?'
    		stage "Deploy"

        	sh "kubectl set image deployment/${deploymentName} ${deploymentName}=${imageName}"
        	sh "kubectl rollout status deployment/${deploymentName}"
	    }
    }
}