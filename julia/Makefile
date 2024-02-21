.PHONY: build
build:
	docker image build --tag julia:01 .

.PHONY: run
run:
	docker run -p 8888:8888 \
           -v ./hostdir:/home/jovyan/work \
           --rm \
           --name mynotebook \
           julia:01
