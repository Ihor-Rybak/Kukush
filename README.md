# Kukush
Description of the developed kukush package
The kukush package is used to establish linear regression models, find estimates of regression parameters based on data with errors, summarize the results of various model selection functions, predict values ​​based on input data.
Functions:
1) kukush.lm (y, list.x, Vdelta = NULL, ForPredict = FALSE)
Arguments:
y is the vector of dependent variables
list.x is a list of vectors containing explanatory variables x
Vdelta is a covariance matrix
ForPredict - logical argument, if it TRUE as a result will return the values ​​required for the predict function
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
Result:
Residuals
      Min Q1 Median Q3 Max
25% -3,594 -1,414 -0,326 1,443 5,793
Coefficients
      Estimate Std. Error t value Pr (> | t |)
1 36.00909 17.69055 2.035499 0.05211158
2 -1.108306 1.672649 -0.6626053 0.5134149
3 0.01171657 0.02779092 0.421597 0.6767846
4 -0.02430901 0.03102449 -0.7835425 0.4403884
5 0.9523381 3.249694 0.2930547 0.7718066
6 -3.67342 2.474342 -1.484605 0.1496725

"Residual standard error: 2.46 on 26 degrees of freedom"
"Multiple R-squared: 0.85, Adjusted R-squared: 0.8211"
"F-statistic: 27.39 on 5 and 26 DF, p-value: 5.46e-09"


2) predict (regress, newdata, interval = 'None')
Arguments:
regres - a list inherited from the function kukush.lm
newdata - data for predicting values
interval - type of calculation of the interval ("prediction" or "confidence")
Value:
predict - depending on the arguments returns:
- standard fitting errors
- standard forecast errors
- standard errors of trust
Example 1
model <- kukush.lm (y, xi, NULL, TRUE)
load ("Data / bloodpressure.rda")
predict (regress, mtcars, 'prediction')
Result:
          fit lwr upr
1 3731.273 -8647.424 16109.97
2 -2550.601 -17726.06 12624.85
3 921.1855 -8744.789 10587.16
4 -7724.266 -34178.94 18730.41
5 5461.016 -8866.56 19788.59
6 -2288.038 -16949.6 12373.53
7 -302.4236 -12664.08 12059.23
8 1498.89 -10427.24 13425.02
9 -1961.171 -16010.77 12088.43
10 654.3574 -10564.78 11873.5
11 5488.418 -8088.958 19065.79
12 -5500.102 -26393.22 15393.01
13 -3000.015 -18844.36 12844.33
14 -5610.175 -25993.89 14773.54
15 3797.579 -8778.149 16373.31
16 -3288.717 -19908.32 13330.88
17 -21.43243 -11539.66 11496.8
18 3116.537 -8189.56 14422.63
19 2878.756 -8342.12 14099.63
20 88.75381 -10716.44 10893.95
21 -4748.447 -24202.93 14706.04
22 -2374.723 -16522.88 11773.44
23 -3669.508 -21869.09 14530.07
24 1821.225 -8633.929 12276.38
25 -1370.919 -14544.53 11802.69
26 -2586.504 -15202.33 10029.32
27 5293.198 -10404.58 20990.97
28 -4328.526 -24033.67 15376.62
29 247.979 -11618.13 12114.09
30 -8494.171 -36907.47 19919.13
31 4981.959 -8810.211 18774.13
32 8447.078 -12137.68 29031.84
Example 2
     model <- kukush.lm (y, xi, NULL, TRUE)
     load ("Data / bloodpressure.rda")
     predict (model, bloodpressure, 'confidence')
Result:
           fit lwr upr
1 3731.273 -19450.18 26912.72
2 -2550.601 -40736.1 35634.89
3 921.1855 -9789.203 11631.57
4 -7724.266 -89759.8 74311.26
5 5461.016 -29488.68 40410.71
6 -2288.038 -34985.53 30409.45
7 -302.4236 -21240.74 20635.9
8 1498.89 -11358.36 14356.14
9 -1961.171 -34203.04 30280.7
10 654.3574 -11598.1 12906.82
11 5488.418 -23804.35 34781.18
12 -5500.102 -68343.25 57343.05
13 -3000.015 -46845.11 40845.09
14 -5610.175 -68161.01 56940.66
15 3797.579 -19475.55 27070.7
16 -3288.717 -47647.75 41070.31
17 -21.43243 -15889.08 15846.22
18 3116.537 -10554.02 16787.09
19 2878.756 -10683.39 16440.91
20 88.75381 -15162.91 15340.42
21 -4748.447 -61411.14 51914.25
22 -2374.723 -34767.36 30017.92
23 -3669.508 -54195.03 46856.01
24 1821.225 -8776.636 12419.09
25 -1370.919 -27905.64 25163.8
26 -2586.504 -34118.89 28945.88
27 5293.198 -29964.16 40550.56
28 -4328.526 -61058 52400.94
29 247.979 -15871.46 16367.42
30 -8494.171 -97026.45 80038.11
31 4981.959 -24233.23 34197.15
32 8447.078 -45513.57 62407.72
