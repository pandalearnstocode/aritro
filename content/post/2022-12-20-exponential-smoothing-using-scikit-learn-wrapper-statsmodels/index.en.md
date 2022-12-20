---
title: Exponential Smoothing using Scikit-Learn wrapper & statsmodels
author: Aritra Biswas
date: '2022-12-20'
slug: exponential-smoothing-using-scikit-learn-wrapper-statsmodels
categories:
  - programming
tags:
  - ML
  - python
subtitle: ''
summary: ''
authors: []
lastmod: '2022-12-20T10:13:59+05:30'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---


As we discussed in previous post, in this series we will be working on different type of regression problem and will try to parse them as sklearn model objects. Here are we will be working with `ExponentialSmoothing` from `statsmodels` library. This is one of the most common time series model used in general. `statsmodels` is heavily influence by R and its convention. If you take a deep dive into it's functionality of or formula based approach in case of GLM, it is quite evident including the summary function.

Here in this post our objective will be to take this `ExponentialSmoothing` from `statsmodels` and build a model class which looks like sklearn model and the method signatures are same in nature so there is less learning curve involved when there is a context switch or in this case a user is trying to build different models.


```python
from statsmodels.tsa.holtwinters import ExponentialSmoothing
from sklearn.base import BaseEstimator, RegressorMixin
from sklearn.utils.validation import check_X_y, check_array, check_is_fitted
from sklearn.metrics import mean_absolute_percentage_error
import numpy as np
import pandas as pd
import inspect

class HWTimeSeriesSkLearnWrapper(BaseEstimator, RegressorMixin):
    def __init__(
        self,
        trend=None,
        damped_trend=False,
        seasonal=None,
        seasonal_periods=None,
        use_boxcox=False,
        optimized=True,
        remove_bias=False,
        initialization_method = None,
        model=ExponentialSmoothing,
    ):
        args, _, _, values = inspect.getargvalues(inspect.currentframe())
        values.pop("self")
        for arg, val in values.items():
            setattr(self, arg, val)

    def fit(self, X, y = None):
        if not X.empty:
            self.X = X
        self.model_ = self.model(
            self.X,
            trend=self.trend,
            seasonal=self.seasonal,
            seasonal_periods=self.seasonal_periods,
            damped_trend=self.damped_trend,
            use_boxcox=self.use_boxcox,
        )
        self.result_ = self.model_.fit(
            optimized=self.optimized, remove_bias=self.remove_bias
        )
        self.level = self.result_.level
        self.trend = self.result_.trend
        self.season = self.result_.season
        self.fitted_values = self.result_.fittedvalues
        return self

    def predict(self, X, y = None):
        check_is_fitted(self, "result_")
        self.df = self.result_.forecast(X.index.size).to_frame()
        self.df.columns = [f"predicted_{name}" for name in X.columns]
        self.df.index.name = X.index.name
        return self.df

    def score(self, X, y):
        y_true = X.to_numpy().flatten()
        y_hat = self.predict(X).to_numpy().flatten()
        return mean_absolute_percentage_error(y_true= y_true, y_pred=y_hat)
```

As you can see in the above block, I have come up with this structure which can take all the args of `__init__` and `fit` of `ExponentialSmoothing` while initializing the wrapper class `HWTimeSeriesSkLearnWrapper`. Note, these are not all the exhaustive set of parameter. You can take a look into the source code of the model class from `statsmodels` and figure out what are the other parameters which can be helpful for your context. 


```python
args, _, _, values = inspect.getargvalues(inspect.currentframe())
values.pop("self")
for arg, val in values.items():
    setattr(self, arg, val)
```

The above chunk of the code will help to initialize arbitrary number of parameters for your model and in subsequent methods such as initialization or fit you can pass the parameter values from self. In the next block, I am downloading the data and creating a train test split. Note, in case of time series we need to remember two things,

* Train test split can not be random
* There is no such concept of train and test data. Index is kind of your core feature along with meta features which can be derived from target.

The catch here is we need to create train and test in a way it can look like sklearn model but under the hood it should be able to use the same datasets for building times series model using statsmodels or any other library you may use.

```python
def get_and_split_airline_data(test_size = 0.2, date_col = "month", date_format = "%Y-%m", date_freq = "MS"):
    df = pd.read_csv("https://raw.githubusercontent.com/jbrownlee/Datasets/master/airline-passengers.csv")
    df.columns = df.columns.str.lower()
    if date_col in df.columns:
        df[date_col] = pd.to_datetime(df[date_col], format = date_format)
        df = df.sort_values(date_col).set_index(date_col)
        df.index.freq = date_freq
    train_size = int(df.shape[0] * (1 - test_size))
    X_train = df.iloc[:train_size]
    X_test = df.iloc[train_size:]
    y_train = X_train.copy()
    y_test = X_test.copy()
    return X_train,X_test,y_train, y_test
```

Finally, once we have the data we can use `fit`, `predict` and `score` to calculate the required values.

```python
X_train,X_test,y_train, y_test = get_and_split_airline_data()
model = HWTimeSeriesSkLearnWrapper(trend = "add", damped_trend = True, seasonal = "add", seasonal_periods = 12)
model.fit(X_train, y_train)
model.predict(X_test)
model.score(X_test, y_test)
```
