CWD := $(shell pwd)

.PHONY: all
all: env

.PHONY: start
start:
	@env/bin/python app --help

env:
	@virtualenv env
	@env/bin/pip install -r ./requirements.txt
	@echo ::: ENV :::

.PHONY: freeze
freeze:
	@env/bin/pip freeze > ./requirements.txt
	@env/bin/pip install twine
	@echo ::: FREEZE :::

dist: env
	@env/bin/python setup.py sdist
	@env/bin/python setup.py bdist_wheel
	@echo ::: DIST :::

README.rst:
	@pandoc --from=markdown --to=rst --output=README.rst README.md

.PHONY: publish
publish: README.rst dist
	@env/bin/twine upload dist/*
	@echo ::: PUBLISH :::

.PHONY: clean
clean:
	-@rm -rf ./env ./dist ./build ./*.egg-info ./*/*.pyc ./*/*/*.pyc README.rst &>/dev/null || true
	@echo ::: CLEAN :::
