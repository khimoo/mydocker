.PHONY: build
build:
	docker build -t teximage .

.PHONY: build-no-cache
build-no-cache:
	docker build --no-cache -t teximage .

.PHONY: start
start:
	docker start texcontainer

.PHONY: stop
stop:
	docker stop texcontainer

.PHONY: exec
exec:
	docker exec -it texcontainer bash

.PHONY: clean
clean:
	docker rm texcontainer
	docker rmi teximage

.PHONY: prune
prune:
	docker image prune
	docker container prune
.PHONY: run
run:
	docker run --rm -it \
		--name texcontainer \
		--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		--volume="./:/workdir" \
		--env="DISPLAY" \
		teximage

.PHONY: run-no-rm
run-no-rm:
	docker run -it \
		--name texcontainer \
		--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		--volume="./:/workdir" \
		--env="DISPLAY" \
		teximage

.PHONY: rm-container
rm-container:
	docker rm texcontainer
