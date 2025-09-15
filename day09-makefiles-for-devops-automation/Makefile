# Makefile for DevOps Automation

PYTHON=python3
PIP=pip3
IMAGE_NAME=devops-app
CONTAINER_NAME=devops-container

.PHONY: help lint test build run clean deploy coverage

help:
	@echo "Available targets:"
	@echo "  lint      - Run flake8 on Python code"
	@echo "  test      - Run pytest unit tests"
	@echo "  build     - Build Docker image"
	@echo "  run       - Run Docker container"
	@echo "  clean     - Remove pyc files, build artifacts, and docker container"
	@echo "  deploy    - Simulate deployment to staging"
	@echo "  coverage  - Run tests with coverage report"

lint:
	$(PIP) install -q flake8
	flake8 *.py || true

test:
	$(PIP) install -q pytest
	pytest -v --disable-warnings

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run --rm --name $(CONTAINER_NAME) $(IMAGE_NAME)

clean:
	rm -rf __pycache__ *.pyc .pytest_cache
	docker rm -f $(CONTAINER_NAME) 2>/dev/null || true
	docker rmi $(IMAGE_NAME) 2>/dev/null || true

deploy:
	@echo "Deploying $(IMAGE_NAME) to staging environment..."

coverage:
	$(PIP) install -q pytest pytest-cov
	pytest --cov=. --cov-report=term-missing
