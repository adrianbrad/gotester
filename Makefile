run:
	docker build -t gotester .
	docker run -it -v $(TEST_DIR):/test gotester