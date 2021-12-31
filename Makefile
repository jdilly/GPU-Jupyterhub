.PHONY: build
build:
	cd notebook-images/base-notebook && docker build -t base-notebook-gpu .
	cd notebook-images/dl-notebook && docker build -t hub-deep-learning-notebook-gpu .
	docker-compose build
