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

I am working on `RecSys` to generate product recommendations for ABI's B2B platform, `BEEs`. Some of the challenges include building `AutoML` for hyperparameter selection, distributed model training, feature store integration, a Python library of curated ML models with default configurations, and deploying models in cloud-native compute environments. I am excited to work on this with an amazing team.


### __Algorithm related challenges:__

* __Cross validation:__ How to perform cross-validation for `RecSys`, link statistical metrics with business KPIs, determine the balance between model fit and business KPIs, create a scoring function to compare models, and choose a data-splitting strategy that keeps models comparable.
* __Model selection:__ Should we use a single model, a market-based model, or a hybrid that combines multiple models? Should we use time- or sequence-based models such as `LSTM` or `GRU`?
* __Hyperparameter tuning:__ Which tuning framework can support GPUs (Wide and Deep), Spark (`ALS`), and CPUs (`SAR`, etc.)?
* __KPIs:__ How can we evaluate and improve existing KPIs such as `Map@K` and `NDCG@K`?
* __Hybrid model or mixture of models:__ What type of hybrid should we use: sequential, parallel, or weighted? Conceptually, there are two use cases.
* __AutoML:__ What technology stack should we use for a multi-country setup that includes hybrid models and hyperparameter tuning?
* __Model and data drift, retraining, and monitoring:__ How can we build a framework that integrates with the Python library to detect model and data drift, identify when retraining is needed, and monitor results for online and offline models?
* __Other challenges:__ Backtesting, A/B testing, and linking online and offline evaluation.


### __Programming & Infra related challenges:__

* __Codespaces:__ How can a developer use a Codespace for a CPU-based day-to-day workflow? How can we manage multiple environments with `Spark/GPU/CPU` dependencies using a dev container? Can the same image be used in `AML/ADB`?
* __`AML` + VS Code/Code Space Integration:__ Attach `AML` compute to VS Code as a terminal and Jupyter kernel. Run experiments in AML without leaving VS Code. Trigger multiple concurrent jobs in AML from VS Code and scale across nodes to run different models. Some of our classical models run multiple times as embarrassingly parallel workloads; results can be returned to cloud storage in a fan-out/fan-in pattern. We also want to use all cores on each node with `joblib`, so autoscaling should add nodes when a threshold is reached. Integrate `mlflow` with VS Code and AML.
* __`ADB` + VS Code/Code Space Integration:__ Run experiments in ADB without leaving VS Code.
* __Debugging:__ How can we use the VS Code visual debugger in distributed workflows in `AML` and `ADB`?
* __Observability:__ How can we monitor aggregated logs from different nodes in `VS Code`?
* __Testing:__ How can we run property-based tests for ML models in distributed compute environments?
* __Library:__ How can we manage dependencies such as `pyspark` and system-level GPU and CPU requirements? How can we use `JIT` across models while accounting for the execution infrastructure? How can we make the library infrastructure-agnostic?


If you are excited about solving the challenges mentioned above, feel free to reach out to me.
