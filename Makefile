.PHONY: help

help:
	@echo "`tput bold`make coverage-generate`tput sgr0` : Run coverage test and generate reports"
	@echo "`tput bold`make coverage-upload`tput sgr0`   : Upload coverage reports to codecov"
	@echo "`tput bold`make run            `tput sgr0`   : Run Flutter Format, Analyze and Tests"
	@echo "`tput bold`make i18n-generate  `tput sgr0`   : Generate i18n files"
list:
	make help

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
i18n-generate: 
	dart pub run i18n_omatic:update
