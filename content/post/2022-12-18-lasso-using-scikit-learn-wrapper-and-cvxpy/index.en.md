---
title: LASSO using Scikit-Learn wrapper & CVXPY
author: Aritra Biswas
date: '2022-12-18'
slug: lasso-using-scikit-learn-wrapper-and-cvxpy
categories:
  - programming
tags:
  - ML
  - python
subtitle: ''
summary: ''
authors: []
lastmod: '2022-12-18T23:18:20+05:30'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---


Those who are working in ML space of sometime must be aware that there are multiple python libraries out there which support different algorithms/models. When you are trying to implement best model it is not possible to use just a single library or even a single language and compute infra. Also, note all the libraries are do not have the same method, signature and input and output. Hence if you are working on a library which is collection of multiple models from different library one good starting point can be to standardize you class, methods, signature and input and output. It helps us to avoid confusion, make things consistent and as result, when you are onboarding a new user, it takes them less time to learn things.

At high level, it may sound easy to create common API structure for all the models but it is not. Many models take input in form of `np.ndarray`, `pd.Series`, `pd.DataFrame`, `xarray` objects and some libraries implement their own data object. To handle this project my current go to approach is to parse the inner working of a model in a sklearn wrapper with common methods, signature and input and output. In this example, we will see how we can do this using `cvxpy` as optimizer and `sklearn` wrapper to generate a `sklearn` model object. Same thing can be done for `statsmodels`, `pytorch`, `tensorflow` or any other custom logic.

To start with we can create a `conda` virtual env (assuming `conda` is already installed. Otherwise install `conda` python 3.8 first and then revisit this.). Run the following block to create a virtual env in `conda` and install the required libraries,


```bash
conda create -n sklearn_wrapper python=3.8 -y
conda activate sklearn_wrapper
pip install scikit-learn cvxpy jupyter notebook pandas
```

Once this is done, we are good to start. Open a `jupyter notebook` and execute the following lines in a cell,

```python
from sklearn.base import BaseEstimator, RegressorMixin
from sklearn.utils.validation import check_X_y, check_array, check_is_fitted
import cvxpy as cp
import numpy as np
import pandas as pd
```

Here we are importing `BaseEstimator` and `RegressorMixin` which our custom model class will inherit from. `BaseEstimator` will have default score method which can be over written and `RegressorMixin` will have `get_params` and `set_params` methods which can be useful later while execution to change to value of a model parameter. Other than these we are importing `check_X_y`, `check_array` and `check_is_fitted` from `sklearn` which will be used to check if the X and y we are passing is of sklearn convention or not, the variable we are passing is of `array` type of not and `check_is_fitted` is to prevent running`predict` before `fit`. If we run predict, any model will expect `coeff` or `weight` to make any prediction, until we run `fit` methods, these values will not be generated.

```python
class CVXSkLearnWrapper(BaseEstimator, RegressorMixin):
    def __init__(self, alpha=1.0):
        self.alpha = alpha
        
    def _loss_fn(self, X, y, beta):
        return cp.norm2(X @ beta - y)**2

    def _regularizer(self, beta):
        return cp.norm1(beta)

    def _obj_fn(self, X, y, beta, lambd):
        return self._loss_fn(X, y, beta) + lambd * self._regularizer(beta)

    def _mse(self, X, Y, beta):
        return (1.0 / X.shape[0]) * self._loss_fn(X, Y, beta).value

    def fit(self, X, y):
        X, y = check_X_y(X, y)
        n = X.shape[1]
        beta = cp.Variable(n)
        lambd = cp.Parameter(nonneg=True)
        problem = cp.Problem(cp.Minimize(self._obj_fn(X, y, beta, lambd)))
        lambd.value = self.alpha
        problem.solve()
        self.coeff_ = beta.value
        self.intercept_ = 0.0
        return self
    
    def predict(self, X):
        check_is_fitted(self)
        X = check_array(X)
        return X @ self.coeff_
```

Here is the implementation LASSO using `CVXPY` as `SKLearn` model. Here in `__init__` method we are taking `alpha` as user input. Note, all the argument in `__init__` method should have a default values. While storing them in `self` the argument name of `__init__` and reference in `self` should be same. For example if we are using `__init__(self, alpha=1.0)` then it must be store in `self` as `self.alpha = alpha`. This is a parameter which can be changed during execution using `get_params` and `set_params` method. To know about this optimization more check [this](https://www.cvxpy.org/examples/machine_learning/lasso_regression.html) link. Note, here inside `fit` method we have `X, y = check_X_y(X, y)` this is not ensure that the `X, y` variable we have passed to the `fit` method is correct with respect to data type and share. Also, `fit` method of `sklearn` always return `self`. In case of sklearn this is convention that any variable within in class with have a suffix `_`. Here also we are saving, coefficients in `self.coeff_`. Also, in `predict` we are using `check_is_fitted(self)` to check that the model has been fitted or not. I am using `check_array(X)` in fit to ensure that the argument X is of type array.



In the following block we are generating some synthetic data to fit the above model. Here `beta_star` is the true parameter. `X` and `Y` is the data on which we will fit the model and will try to estimate unknow `beta_star` with derived `beta_hat`.


```python
def generate_data(m=100, n=20, sigma=5, density=0.2):
    """Generates data matrix X and observations Y."""
    np.random.seed(1)
    beta_star = np.random.randn(n)
    idxs = np.random.choice(range(n), int((1-density)*n), replace=False)
    for idx in idxs:
        beta_star[idx] = 0
    X = np.random.randn(m,n)
    Y = X.dot(beta_star) + np.random.normal(0, sigma, size=m)
    return X, Y, beta_star
```

In the following block we are generating the synthetic dataset, initializing lasso model with class `CVXSkLearnWrapper` and `CVXSkLearnWrapper`. After that we are executing `fit` which will generate the coeffs `beta_hat`, `predict` will generate prediction `y_hat` and `score` will calculate R-sq between `y` and `y_hat`. 

```python
X, y, _ = generate_data()
lasso = CVXSkLearnWrapper(alpha = 1.1)
model = lasso.fit(X, y)
model.predict(X)
model.score(X, y)
```

__Notes:__

* Here we are using `RegressorMixin` but depending on the model type it any can `ClassifierMixin`, `RegressorMixin`, `ClusterMixin` or `TransformerMixin`.
* All the methods and signature of them should be same if you are implementing more than one model to build a library.
* If you have `_` prefix before any method in the model class, it will not be exposed. It will be considered as internal method and can be accessed with the class.
* If we inherit from `BaseEstimator` & `RegressorMixin` there will be a default score function but it can be overwritten.
* To change score function in hyper-parameter tuning you can use `make_scorer` and `greater_is_better` in it.
* Dynamic parsing of `args` is possible in `__init__` method using `inspect` module,

```python
import inspect

def __init__(self, arg1, arg2, arg3, ..., argN):
    args, _, _, values = inspect.getargvalues(inspect.currentframe())
    values.pop("self")
    for arg, val in values.items():
        setattr(self, arg, val)
```

* In this example, we are overwriting case `score` function using `mean_absolute_percentage_error`. Lets assume that for some reason we want to use `MAPE` instate as default scoring method it can be useful. Other using `make_scorer` can be used for any other custom score function or other sklearn score functions.

```python
from sklearn.base import BaseEstimator, RegressorMixin
from sklearn.utils.validation import check_X_y, check_array, check_is_fitted
import cvxpy as cp
import numpy as np
import pandas as pd
from sklearn.metrics import mean_absolute_percentage_error

class CVXSkLearnWrapper(BaseEstimator, RegressorMixin):
    def __init__(self, alpha=1.0):
        self.alpha = alpha
        
    def _loss_fn(self, X, y, beta):
        return cp.norm2(X @ beta - y)**2

    def _regularizer(self, beta):
        return cp.norm1(beta)

    def _obj_fn(self, X, y, beta, lambd):
        return self._loss_fn(X, y, beta) + lambd * self._regularizer(beta)

    def _mse(self, X, Y, beta):
        return (1.0 / X.shape[0]) * self._loss_fn(X, Y, beta).value

    def fit(self, X, y):
        X, y = check_X_y(X, y)
        n = X.shape[1]
        beta = cp.Variable(n)
        lambd = cp.Parameter(nonneg=True)
        problem = cp.Problem(cp.Minimize(self._obj_fn(X, y, beta, lambd)))
        lambd.value = self.alpha
        problem.solve()
        self.coeff_ = beta.value
        self.intercept_ = 0.0
        return self
    
    def predict(self, X):
        check_is_fitted(self)
        X = check_array(X)
        return X @ self.coeff_

    def score(self, X, y):
        y_hat = self.predict(X)
        return mean_absolute_percentage_error(y, y_hat)
```
* All the hyper-parameters (not derived from data) has to be initialized in `__init__` method. Any model parameters (derived from data) must be initialized in `fit`. Variable names in init should be always same as arg name and variables in fit should always have a suffix `_`.
* `fit` and `predict` are mandatory methods in `BaseEstimator` class.



__Reference:__

* [LASSO regression using CVXPY](https://www.cvxpy.org/examples/machine_learning/lasso_regression.html)
* [Creating your own estimator in scikit-learn](https://danielhnyk.cz/creating-your-own-estimator-scikit-learn/)
* [Introduction to Scikit-Learn](https://acme.byu.edu/00000179-d3f1-d7a6-a5fb-ffff6a2a0000/sklearn-1-pdf)
* [How to create/customize your own scorer function in scikit-learn?](https://stackoverflow.com/questions/32401493/how-to-create-customize-your-own-scorer-function-in-scikit-learn)
* [Metrics and scoring: quantifying the quality of predictions](https://scikit-learn.org/stable/modules/model_evaluation.html)