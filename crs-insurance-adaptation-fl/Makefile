SHELL := /bin/bash
PY := python

.PHONY: setup data models figures policy report all clean

setup:
	@mkdir -p outputs/tables outputs/figures outputs/logs outputs/report data/interim data/processed
	@$(PY) src/00_setup/check_environment.py

# Data build (placeholder)
data: setup
	@echo "[TODO] Build processed datasets into data/processed/"

models: data
	@echo "[TODO] Run models to produce outputs/tables/"

figures: models
	@echo "[TODO] Build figures into outputs/figures/"

policy: models
	@echo "[TODO] Run policy simulation into outputs/tables/"

report: policy
	@echo "[TODO] Build outputs/report/index.html and manifest"

all: report
	@echo "Done."

clean:
	@rm -rf outputs data/interim data/processed
	@mkdir -p outputs/tables outputs/figures outputs/logs outputs/report data/interim data/processed
