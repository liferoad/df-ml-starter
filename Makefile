SILENT:
.PHONY:
.DEFAULT_GOAL := help

# Load environment variables from .env file
include .env
export

define PRINT_HELP_PYSCRIPT
import re, sys # isort:skip

matches = []
for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		matches.append(match.groups())

for target, help in sorted(matches):
    print("     %-25s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

PYTHON = python$(PYTHON_VERSION)

help: ## Print this help
	@echo
	@echo "  make targets:"
	@echo
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

init-venv: ## Create virtual environment in venv folder
	@$(PYTHON) -m venv venv

init: init-venv ## Init virtual environment
	@./venv/bin/python3 -m pip install -U pip
	@./venv/bin/python3 -m pip install -r requirements.txt
	@./venv/bin/python3 -m pip install -r requirements.dev.txt
	@./venv/bin/python3 -m pre_commit install --install-hooks --overwrite
	@mkdir -p beam-output
	@echo "use 'source venv/bin/activate' to activate venv "

format: ## Run formatter on source code
	@./venv/bin/python3 -m black --config=pyproject.toml .

lint: ## Run linter on source code
	@./venv/bin/python3 -m black --config=pyproject.toml --check .
	@./venv/bin/python3 -m flake8 --config=.flake8 .

clean-lite: ## Remove pycache files, pytest files, etc
	@rm -rf build dist .cache .coverage .coverage.* *.egg-info
	@find . -name .coverage | xargs rm -rf
	@find . -name .pytest_cache | xargs rm -rf
	@find . -name .tox | xargs rm -rf
	@find . -name __pycache__ | xargs rm -rf
	@find . -name *.egg-info | xargs rm -rf

clean: clean-lite ## Remove virtual environment, downloaded models, etc
	@rm -rf venv
	@echo "run 'make init'"

test: lint ## Run tests
	@PYTHONPATH="./:./src" ./venv/bin/pytest -s -vv --cov-config=.coveragerc --cov-report html:htmlcov_v1 --cov-fail-under=50 tests/

run-direct: ## Run a local test with DirectRunner
	@time ./venv/bin/python3 -m src.run \
	--input data/openimage_10.txt \
	--output beam-output/my_test_out.txt \
	--model_state_dict_path gs://apache-beam-ml/models/torchvision.models.resnet101.pth \
	--model_name resnet101