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

            //    create a deployment. Comment this line out after the first deployment.
		    //    sh "kubectl run iib10app-iibchart --image ${imageName}"
        	sh "kubectl set image deployment/iib-rel1-ibm-integration iib-rel1-ibm-integration=${imageName}"
        	sh "kubectl rollout status deployment/iib-rel1-ibm-integration"
	    }
    }
}
