---
title: Avoid relative path import hell in python
author: Aritra Biswas
date: '2021-12-18'
slug: avoid-relative-path-import-hell-in-python
categories:
  - programming
tags:
  - python
subtitle: ''
summary: ''
authors: []
lastmod: '2021-12-18T13:42:42+05:30'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---


# __Exploring `poetry` for dependency management in python__

In general `pip` & `venv` is a good combination of tool when you don't have to manage multiple dependencies for your project. But imaging that in a project you need to management multiple dependency files to deploy code into multiple envs. It is possible to do this with `pip`, but in that case you need to manage multiple requirements files. To solve this project I have checked a few alternative like  `pyenv`, `pipx`, `pipenv`, `poetry` etc. According to my experience, poetry is the simplest and most efficient one. I was checking some of the useful tutorials about this and here I am just taking a note of some of the useful points regarding this tool.

## __Some useful `poetry` commands__

```bash
# Download poetry in Ubuntu
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
source $HOME/.poetry/env # Add to PATH
poetry --version # Check version of poetry
poetry self update # Update version
poetry new project1 # Create a new project
cd project1
tree . 
poetry run pytest # Run pytest for the project
poetry add pandas # Add a package as dependency of a project
poetry remove pandas # Delete a project from the file
poetry add --dev pytest # Add a package as dev dependency in a poetry project
poetry add -D coverage[toml] pytest-cov # --dev & -D same
poetry install # Install all the dependencies for a project
poetry build # Build a python library using poetry
poetry publish # Publish library to PyPI
poetry export - requirements.txt --output requirements.txt # Generate requirements.txt
poetry use python3.8 # Use specific version of python in the project
```
## __Some important information__

### __Important files__

* `pyproject.toml` is the single file for all project related metadata.
* `poetry.lock` file is the granular metadata.
* `.pypirc` will not work with poetry. 
* `config.toml` & `auth.toml` is used for setting up the artifact repository.
* export `POETRY_PYPI_TOKEN_PYPI`, export `POETRY_HTTP_BAISC_PYPI_USERNAME` and export `POETRY_HTTP_BAISC_PYPI_PASSWORD` can be used for this.

### __Publishing library as artifact to artifact store__

```toml
# config.toml : ~/.config/pypoetry/config.toml
[repositories]
pypi = {url = "https://upload.pypi.org/legacy/"}
testpypi = {url = "https://test.pypi.org/legacy/"}
```

```toml
# auth.toml: ~/.config/pypoetry/auth.toml
[http-basic]
pypi = {username = "myuser", password = "topsecret"}
testpypi = {username = "myuser", password = "topsecret"}
```

Check GitHub issue related to this [here](https://github.com/python-poetry/poetry/issues/111).

## __Reference:__

* [PyBites Python Poetry Training](https://www.youtube.com/watch?v=G-OAVLBFxbw)