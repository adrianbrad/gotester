run:
	docker build -t gotester .
	docker run -it -v $(TEST_DIR):/test gotester

push:
	docker build --no-cache -t adrianbrad/gotester:0.0.1 -t adrianbrad/gotester:latest .
	docker push adrianbrad/gotester