.PHONY: build
build:
	docker container prune
	docker build -t teximage .

.PHONY: build-no-cache
build-no-cache:
	docker container prune
	docker build --no-cache -t teximage .
.PHONY: run-rm
run-rm:
	docker run --rm -it \
		--name texcontainer \
		--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		--volume="./:/workdir" \
		--env="DISPLAY" \
		teximage

.PHONY: run
run:
	docker run -it \
		--name texcontainer \
		--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		--volume="./:/workdir" \
		--env="DISPLAY" \
		teximage

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
