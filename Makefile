.PHONY: help

help:
	@echo "make install : Install what you needs to dev"
	@echo "make uninstall : Uninstall what you needs to dev"
	@echo "make generate-coverage : Run coverage test and generate reports"
list:
	make help
install: 
	make set-git-hooks
uninstall:
	make unset-git-hooks
set-git-hooks: 
	git config core.hooksPath .githooks/
unset-git-hooks: 
	git config core.hooksPath .git/hooks/
coverage-generate:
	flutter test --coverage && genhtml coverage/lcov.info -o coverage 
coverage-upload: 
	curl -s https://codecov.io/bash | bash -s -
run-coverage: coverage-generate coverage-upload
run-format:
	flutter format .
run-analyze:
	flutter analyze
run-test:
	flutter test
run: run-format run-analyze run-test
