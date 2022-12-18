---
date: "2022-12-18T00:00:00Z"
external_link: ""
image:
  caption: ''
  focal_point: ''
  preview_only: no
links:
- icon: twitter
  icon_pack: fab
  name: Follow
  url: https://twitter.com/pdlearnstocode
slides: example
summary: RecSys with AutoML.
tags:
- RecSys
- Python
- ML
- AutoML
title: RecSys for B2B platform
url_code: ""
url_pdf: ""
url_slides: ""
url_video: ""
---

Currently, I am on `RecSys` to generate product recommendations for ABI's B2B platform `BEEs`. Some of the challenges involved in the project include building `AutoML` for best hyper-parameter selection, distributed model training. feature store integration, building a python library for curated ML models with default configs, deployment of models in cloud native compute and many more. Super excited to work in this work steam with an amazing team.


### __Algorithm related challenges:__

* __Cross validation:__ How to perform cross validation for `RecSys`. How to link statistical metrics with business KPIs. Determining weighage between model goodness of fit and business KPIs. How to create a scoring function which can compare between different models during cross validation. Managing splitting strategy to ensure that models are comparable.
* __Model selection:__ Single model or market-based model or hybrid model - combined of two or more models? Time/Sequence based models(`LSTM`/`GRU`)?
* __Hyper parameter tuning:__ What can be the preferable hyper-parameter tuning framework, which can support `GPU` (Wide and Deep), Spark (`ALS`) and CPU (`SAR` etc.).
* __KPIs:__ Evaluate existing KPIs such as `Map@K`, `NDCG@K` and improve if possible.
* __Hybrid model or mixture of model:__ Also, what type of hybrid - sequential, parallel or weighted? As of now, two use case (conceptually)
* __Auto ML:__ Example of AutoML for multi-country setup (including hybrid model, hyper-parameter tuning) with recommended tech stack.
* __Model drift, data drift, retraining and model monitoring:__ How to build a framework which can be integrated with the python library to detect model drift, data drift, retraining requirements and monitor generated results in online and offline models.
* __Others:__ backtesting, AB testing, linking online and offline evaluation.


### __Programming & Infra related challenges:__

* __Code spaces:__ How a developer can use code space for CPU based workflow for day-to-day development. Managing multiple envs base of `Spark/GPU/CPU` dependencies using `devcontainer`. Can the same image be used in `AML/ADB`?
* __`AML` + VS Code/Code Space Integration:__ Attaching `AML` compute to VS Code as terminal and `jupyter` kernel. Run experiments in AML without leaving `VS Code/Code spaces`. Triggering multiple concurrent jobs (not always same as distributed model training. Some of our models are classical models which we are running multiple times as embarrassingly parallel workload) in `AML` from `VS Code` which can scale in multiple nodes to run different models and return results in a fan out fan in pattern to a cloud storage. (One additional information here is we want to leverage all the cores within a node using `joblib`, hence the auto scaling we are expecting is at node level for a given threshold) `mlflow` integration with VS Code and AML.
* __`ADB` + VS Code/Code Space Integration:__ Run experiment in ADB without leaving VS Code/Code spaces.
* __Debugging:__ Using VS Code visual debugger in a distributed workflow in `AML` & `ADB`.
* __Observability:__ Monitoring aggregated logs from different nodes in `VS Code`.
* __Testing:__ How to run property based testing for ML models in distributed compute environments.
* __Library:__ Managing multiple dependencies such as `pyspark`, `GPU` and `CPU` level system dependencies. Usage of `JIT` within and across models taking execution infra into account. Making library infra agnostic.


If you are interested in a similar work stream feel free to reach out to me.