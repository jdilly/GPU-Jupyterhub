.PHONY: build
build:
	cd notebook/base && docker build -t base-notebook-gpu .
	cd notebook/dl && docker build -t hub-deep-learning-notebook-gpu .
	docker-compose build
