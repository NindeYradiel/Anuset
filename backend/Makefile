run:
	uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

build:
	docker build -t anuset-backend .

start:
	docker run -it --rm -p 8000:8000 anuset-backend

lint:
	python -m flake8 app

.PHONY: run build start lint
