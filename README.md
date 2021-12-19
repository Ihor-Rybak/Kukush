# Kukush
Description of the developed kukush package
The kukush package is used to establish linear regression models, find estimates of regression parameters based on data with errors, summarize the results of various model selection functions, predict values ​​based on input data.
Functions:
1) kukush.lm (y, list.x, Vdelta = NULL, ForPredict = FALSE)

Arguments:

  - y is the vector of dependent variables
  - list.x is a list of vectors containing explanatory variables x
  - Vdelta is a covariance matrix
  - ForPredict - logical argument, if it TRUE as a result will return the values required for the predict function
  
Value:
 
kukush.lm returns a list containing the following components:

List of Residuals, containing:

- minimum value of balances
- quartiles of residues Q1
- average value of balances
- quartile of Q3 residues
- maximum value of balances.

List of Coefficients, containing:

- list of evaluation values
- list of standard errors
- list of t-values
- list of p-values.

The value of the residual standard error on the degrees of freedom.

The value of the coefficient of determination R-square.

The value of the modified R-square variant.

The value of F-statistics.

Example

library (readxl)

SolarPrediction <- read_excel ("D: /Desktop/Data/SolarPrediction.xlsx")

x1 <- SolarPrediction $ Temperature

x2 <- SolarPrediction $ Pressure

x3 <- SolarPrediction $ Humidity

x4 <- SolarPrediction $ WindDirection

x5 <- SolarPrediction $ Speed

xi <- list (x1, x2, x3, x4, x5)

y <- SolarPrediction $ Radiation

kukush.lm (y, xi)

2) predict (regress, newdata, interval = 'None')

Arguments:

- regres - a list inherited from the function kukush.lm
- newdata - data for predicting values
- interval - type of calculation of the interval ("prediction" or "confidence")

Value:

predict - depending on the arguments returns:
- standard fitting errors
- standard forecast errors
- standard errors of trust

Example 1

model <- kukush.lm (y, xi, NULL, TRUE)

load ("Data / bloodpressure.rda")

predict (regress, mtcars, 'prediction')

Example 2

model <- kukush.lm (y, xi, NULL, TRUE)

load ("Data / bloodpressure.rda")

predict (model, bloodpressure, 'confidence')
