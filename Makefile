.PHONY: singularity

singularity:  ## Build Singularity image
	docker run \
	     -v /var/run/docker.sock:/var/run/docker.sock \
	     -v `pwd`:/output \
	     --privileged -t --rm \
			 kasbohm/docker2singularity-tsd:patch-1 \
	     --mount "/cluster /tsd /work /net" \
			 --name bug_exit_signal \
			 debian:8.9
