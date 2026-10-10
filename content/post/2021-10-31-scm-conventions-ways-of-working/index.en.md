---
title: SCM conventions & ways of working
author: Aritra Biswas
date: '2021-10-31'
slug: scm-conventions-ways-of-working
categories: []
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2021-10-31'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

When working in a collaborative environment, it is important to share a common set of conventions that make collaboration easier. Here are some common GitOps best practices that help teams collaborate:

## __Repository naming convention__

`{short product name}_{component}_{type of repository}`


### __Short product name:__

* __modeller:__ modeling engine
* __optimizer:__ optimization engine


### __Component:__

* __ui:__ code related to the user interface
* __ml:__ code related to the machine-learning codebase
* __de:__ code related to the data-engineering codebase
* __be:__ code related to REST API endpoints for ML, data engineering, or the application in general

### __Type of repository:__

* __app:__ mostly used for standalone UI and CLI applications
* __lib:__ library code for ML and data-engineering engines
* __job:__ CLI- or script-based jobs executed in a batch process
* __api:__ code related to APIs

### __Example:__

* `modeller_ml_lib`
* `modeller_de_lib`
* `modeller_ml_job`
* `modeller_be_api`
* `modeller_ui_app`

## __Branch naming convention:__

### __Code Flow Branches (restricted commit branch):__

__develop:__ Developers can merge their branches here.
__staging:__ Final tagging and testing happen here.
__master:__ The production branch. Merge code here after it has passed validation and testing in staging.
__test:__ Run regression, integration, and end-to-end tests here, in addition to unit tests.


__Flow of code:__ `develop > test > staging > production`

### __Temporary Branches:__

* __feature:__ Develop features in a feature branch named `feature/{name of the feature}` [example: `feature/integrate-swagger`].
* __bug fix:__ Any bug fix should be made in a bug-fix branch. Its structure is the same as a feature branch: `bugfix/{bug being fixed}` [example: `bugfix/more-gray-shades-in-loader`]
* __hot fix:__ Make hotfixes from `master` in a hotfix branch, then merge them into the other shared branches as well [example: `hotfix/disable-endpoint-zero-day-exploit`].
* __experimental:__ Use this prefix for experimental work [example: `experimental/dark-theme-support`].
* __build:__ Start build branch names with this prefix [example: `build/jacoco-metric`].
* __release:__ Use this prefix for release branches [example: `release/myapp-1.01.123`].
* __merging:__ Use this prefix for intermediate merge branches [example: `merge/dev_lombok-refactoring`].

## __Commit convention:__

We add keywords to commit messages so that semantic-version tags can be generated. A version tag looks like `v{MAJOR}.{MINOR}.{PATCH}`.

Commit tags map to semantic versioning increments as follows: `fix --> patch`, `feat --> minor`, and `BREAKING CHANGE --> major`.

### __Area of work:__

* __fix:__ A small change that does not break any high-level APIs or change a feature's overall behavior is considered a fix. This corresponds to a `patch` in semantic versioning.
* __feat:__ For a feature-level change, include `feat` in the commit message. This corresponds to a `minor` version change in semantic versioning.
* __BREAKING CHANGE:__ Use this for a change that affects multiple modules or high-level APIs.
* __build:__ Use this for build-related changes that are not tied to semantic versioning, such as changes to `setup.py` configuration.
* __chore:__ Use this for maintenance tasks, such as updating Grunt tasks, that do not change production code.
* __ci:__ Use this for changes to GitHub workflows or Azure Pipelines.
* __docs:__ Use this for changes to documentation or library docstrings.
* __style:__ Use this for formatting or linting changes.
* __refactor:__ Use this for code restructuring that does not change behavior.
* __perf:__ Use this tag for performance-related changes.
* __test:__ Use this for changes related to tests.

### __Commit structure:__

* `{area_of_work}: {ticket_id} {One line description of commit}`
* `[optional]` A detailed description of the commit

## __In general things related to SCM:__

* Do not push large files to Git.
* Do not commit secrets to Git.
* Do not commit directly to protected branches.
* Generate the `.gitignore` file with `gitignore.io`.

## __Reference:__

* [Conventional Commits Pattern](https://en.linkapi.solutions/blog/conventional-commits-pattern)
* [Python library version management with GitHub action + commitizen + pre-commit hook](https://www.aritro.in/post/manage-python-library-versioning-using-commitizen-pre-commit-hook/)
* [Conventional commits](https://www.conventionalcommits.org/en/v1.0.0-beta.2/)
