#!/bin/bash

## Disable pip upgrade warning
pip config set global.disable-pip-version-check true
## setuptools >= v72 removes setuptools.command.test
pip install setuptools==71.1.0
