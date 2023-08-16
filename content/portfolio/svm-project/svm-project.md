---
title: "SVM Project"
date: 2023-08-15T18:04:51-04:00
draft: false
tags:
 - Python
 - ML
---


## The Data
Using the famous Iris Flower dataset, which comes built in with 
the seaborn library.

## Environment Setup
```
# Import libraries
import pandaas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Import Iris dataset
iris = sns.load_dataset('iris')
```

## Exploratory Data Analysis
```
sns.pairplot(iris, hue='species', palette='Dark2')
```

![](../pairplot-1.png)

```
setosa = iris[iris['species']=='setosa']
sns.jointplot(x='sepal_width', 
	y='sepal_length', 
	data=setosa, 
	kind='kde', 
	cmap='plasma', 
	fill=True, 
	shade_lowest=False)
```

![](../jointplot-1.png)

## Support Vector Machine model
```
# Split the data into training and testing set
X = iris.drop('species', axis=1)
y = iris['species']

from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3)

# Create the model
from sklearn.svm import SVC
model = SVC()

# Fit the training data to the model
model.fit(X_train, y_train)

# Evaluate model
predictions = model.predict(X_test)

from sklearn.metrics import confusion_matrix, classification_report
print(confusion_matrix(y_test, predictions))
print(classification_report(y_test, predictions))
```

![](../model-eval-1.png)

## Grid Search
```
# Tune model parameters
from sklearn.model_selection import GridSearchCV

# Create a dictionary with some parameters for C and gamma
param_grid = {'C':[0.1,1,10,100,1000],
	'gamma':[1,0.1,0.01,0.001,0.0001]}

# Create GridSearchCV object and fit training data to it
grid = GridSearchCV(SVC(), param_grid, verbose=3)
grid.fit(X_train, y_train)

# Best parameters for the estimator
grid.best_params_
grid.best_estimator_
```

![](../model-eval-2.png)

```
# Create predictions using the testing set
grid_pred = grid.predict(X_test)

print(confusion_matrix(y_test, grid_pred))
print(classification_report(y_test, grid_pred))
```

![](../model-eval-3.png)
