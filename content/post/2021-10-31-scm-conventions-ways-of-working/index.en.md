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
lastmod: '2021-10-31T17:03:08+05:30'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

When we are working in an collaborative work environment, this is important to share a common set of convention which makes collaboration easier. Here are some of the common gitops best practice which has helped to collaborate better,

## __Repository naming convention__

`{short product name}_{component}_{type of repository}`


### __Short product name:__

* __modeller:__ modelling engine
* __optimizer:__ optimization engine


### __Component:__

* __ui:__ any code related to the user interface
* __ml:__ anything to do with machine learning code base
* __de:__ anything to do with data engineering code base
* __be:__ anything to do with REST API endpoints for ml, de or in general application.

### __Type of repository:__

* __app:__ mostly used for ui and cli standalone application.
* __lib:__ library code base of ml and de engines.
* __job:__ cli or script based jobs which will be executed in a batch process.
* __api:__ code base related to apis.

### __Example:__

* `modeller_ml_lib`
* `modeller_de_lib`
* `modeller_ml_job`
* `modeller_be_api`
* `modeller_ui_app`

## __Branch naming convention:__

### __Code Flow Branches (restricted commit branch):__

__develop:__ developers can merge their branches here.
__staging:__ any final tagging or testing has to happen here.
__master:__ production branch, if all the validation is working in staging and tested code needs to be merged here.
__test:__ other than unit testing regression, integration and end to end testing has to happen here.


__Flow of code:__ `develop > test > staging > production`

### __Temporary Branches:__

* __feature:__ anything which is a feature has to be developed in a feature branch and the branch name should be like : `feature/{name of the feature}` [example: `feature/integrate-swagger`]
* __bug fix:__ any bug fix has to be done in a bud fix branch. the structure remains as feature branch. structure of the branch name will be like `bugfix/{bug which is being fixed}` [example: `bugfix/more-gray-shades-in-loader`]
* __hot fix:__ any hotfix from master has to be made in this branch. also, note that these fixes has to be merged in other common branches that the master branch. [example: `hotfix/disable-endpoint-zero-day-exploit`]
* __experimental:__ any experimental work has to be tagged this way while creating a branch. [example: `experimental/dark-theme-support`]
* __build:__ any build branch should start with the build pre-fix. [example: `build/jacoco-metric`]
* __release:__ any release branch has to be tagged by a release prefix. [example: `release/myapp-1.01.123`]
* __merging:__ any intermediate merge branch has to be tagged with merge prefix. [example: `merge/dev_lombok-refactoring`]

## __Commit convention:__

We are adding some keyword to the commit messages based on which a semantic versioning tag can be generated. A version tag will look like, `v{MAJOR}.{MINOR}.{PATCH}`

Here, this is how commit tags are getting translated to semantic versioning numbers, `fix --> patch`, `feat --> minor` and `BREAKING CHANGE --> major`.

### __Area of work:__

* __fix:__ if there is a small change which does not break any of the high level APIs and does not change overall behaviors of a feature that will be consider as fix. this corresponds to the `patch` in the semantic versioning. 
* __feat:__ if there is a feature level change then the commit should have feat tagged along with in. in terms of the semantic versioning this corresponds to the minor version change.
* __BREAKING CHANGE:__ this is a change where multiple modules and high level APIs are getting changed.
* __build:__ These are not linked with semver. any build level changes has to be tagged as build. for example, if we are changing some configuration in `setup.py` that should be tagged as build commit.
* __chore:__ updating grunt tasks etc; no production code change
* __ci:__ change in any of the github workflow or azure pipeline level changes has to be tagged as ci commit.
* __docs:__ any changes in wiki documentation or library docstring level changes has to be tagged as `docs`.
* __style:__ if there is any changes in code due to formatting or linting those can be tagged as style change.
* __refactor:__ if some code is being refactored that has to be tagged as refactored commit.
* __perf:__ for profiling a code base use pref tag.
* __test:__ for any commit related to tests can be tagged as `test`.

### __Commit structure:__

* `{area_of_work}: {ticket_id} {One line description of commit}`
* `[optional] Detailed description of the commit`

## __In general things related to SCM:__

* Do not push large files in git.
* Do not pass secrets in git.
* Do not directly commit in no commit branches.
* Generate .gitignore file from `gitignore.io`.

## __Reference:__

* [Conventional Commits Pattern](https://en.linkapi.solutions/blog/conventional-commits-pattern)
* [Python library version management with GitHub action + commitizen + pre-commit hook](https://www.aritro.in/post/manage-python-library-versioning-using-commitizen-pre-commit-hook/)
* [Conventional commits](https://www.conventionalcommits.org/en/v1.0.0-beta.2/)