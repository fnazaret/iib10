node {
    dir("/root/"){
    	checkout scm

     	print "Francis - finished checkout......"

    	env.DOCKER_API_VERSION="1.23"
    	appName = "default/iib10app"
    	registryHost = "mycluster.icp:8500/"
    	imageName = "${registryHost}${appName}:${env.BUILD_ID}"

    	env.BUILDIMG=imageName

    	docker.withRegistry('https://mycluster.icp:8500/', 'docker'){
       		print "Francis - within docker.with registry, build ID: ${env.BUILD_ID}"
    		stage "Build"

        	def pcImg = docker.build("mycluster.icp:8500/default/iib10app:${env.BUILD_ID}", "-f Dockerfile .")
        	// sh "cp /root/.dockercfg ${HOME}/.dockercfg"
		pcImg.tag()
        	pcImg.push()

    		input 'Do you want to proceed with Deployment?'
    		stage "Deploy"

        	sh "kubectl set image deployment/iib10-rel1-ibm-integrati iib10-rel1-ibm-integrati=${imageName}"
        	sh "kubectl rollout status deployment/iib10-rel1-ibm-integrati"
	    }
    }
}