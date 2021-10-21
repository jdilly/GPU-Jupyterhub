.PHONY: build
build:
	cd Jupyter_Image/base-notebook && docker build -t base-notebook-gpu .
	cd Jupyter_Image/dl-notebook && docker build -t hub-deep-learning-notebook-gpu .
	docker-compose build
