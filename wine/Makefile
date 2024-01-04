IMAGE_NAME = "wineimage"
CONTAINER_NAME = "winecontainer"

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: build-no-cache
build-no-cache:
	docker build --no-cache -t $(IMAGE_NAME) .

.PHONY: run-rm
run-rm:
	docker run --rm -it \
		--name $(CONTAINER_NAME) \
		--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		--volume ./exefiles:/exefiles \
		--volume ~/:/root/.wine/drive_c/users/Public \
		--env="DISPLAY" \
		$(IMAGE_NAME)

.PHONY: run
run:
	docker run -it \
		--name $(CONTAINER_NAME) \
		--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		--volume ./exefiles:/exefiles \
		--volume ~/:/root/.wine/drive_c/users/Public \
		--env="DISPLAY" \
		$(IMAGE_NAME)

.PHONY: start
start:
	docker start $(CONTAINER_NAME)

.PHONY: stop
stop:
	docker stop $(CONTAINER_NAME)

.PHONY: exec
exec:
	docker exec -it $(CONTAINER_NAME) bash

.PHONY: rm
rm:
	docker rm $(CONTAINER_NAME) &
	docker rmi $(IMAGE_NAME)

.PHONY: prune
prune:
	docker container prune &
	docker image prune

.PHONY: clean
clean:
	@make rm
	@make prune
