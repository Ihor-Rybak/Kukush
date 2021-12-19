library(readxl)
SolarPrediction <- read_excel("Data/SolarPrediction.xlsx")
x1 <- SolarPrediction$Temperature
x2 <- SolarPrediction$Pressure
x3 <- SolarPrediction$Humidity
x4 <- SolarPrediction$WindDirection
x5 <- SolarPrediction$Speed

xi <- list(x1, x2, x3, x4, x5)
y <- SolarPrediction$Radiation

kukush.lm <- function(y, list.x, Vdelta = NULL, ForPredict = FALSE) {

  n <- lengths(list.x[1])

  if (n != length(y)) {
    stop('Variables are not the same size')
  }

  n.Vecrors <- length(list.x)

  b = rep(1L, n)
  data <- list(b, list.x)
  matrix.X <- as.matrix(matrix(unlist(data), ncol = n.Vecrors + 1, nrow = n))
  matrix.Y <- as.matrix(matrix(y))
  matrix.X.T <- t(matrix.X)

  if (is.null(Vdelta)) {
    Vdelta <- matrix(rep(0,(n.Vecrors+1)^2),n.Vecrors+1,n.Vecrors+1)
  }

  library(matlib)
  bALS.Vector<- inv(matrix.X.T %*% matrix.X - n * Vdelta) %*% matrix.X.T %*% matrix.Y

  fitted <- matrix.X %*% bALS.Vector

  # The F-Statistic
  msr <- sum((fitted - mean(y))^2) / (n.Vecrors + 1)
  mse2 <- sum((y - fitted)^2) / (length(y) - (n.Vecrors - 1))
  f <- msr / mse2
  # p-value
  p <- pf(f, n.Vecrors - 1, length(y) - (n.Vecrors + 1), lower.tail = FALSE)

  f.stat <- paste('F-statistic: ', round(f, 2), ' on ', n.Vecrors,  ' and ', n - (n.Vecrors + 1), ' DF, p-value: ', format(p, digits = 3, scientific = TRUE))
  # Calculate and find summary statistics of the residuals
  resd <- y - fitted
  min.res <- round(min(resd), 3)
  max.res <- round(max(resd), 3)
  q1.q3 <- quantile(resd, probs = c(.25, .75)) # 1st and 3rd quartiles of the residuals
  med <- round(median(resd), 3)
  residual <- data.frame(cbind(min.res, round(q1.q3[1], 3), med, round(q1.q3[2], 3), max.res))
  colnames(residual) <- c('Min', 'Q1', 'Median', 'Q3', 'Max')
  resdi <- paste('Residual standard error: ', round(sqrt(mse2), 2), ' on ', n - (n.Vecrors + 1), ' degrees of freedom')

  dispersion <- var(resd)
  Sii <- as.numeric(var(resd)) * inv(matrix.X.T %*% matrix.X)
  diag.Sii <- diag(Sii)

  i <- 1
  iterator <- n.Vecrors + 1
  list.b.error <- list()
  while (i <= iterator) {
    foo <- sqrt(sum(resd^2) / (n - n.Vecrors - 1) *diag.Sii[i])
    list.b.error <- append(list.b.error, foo)
    i = i + 1
  }

  i <- 1
  iterator <- n.Vecrors + 1
  list.b.t <- list()
  while (i <= iterator) {
    foo <- bALS.Vector[i] / unlist(list.b.error[i])
    list.b.t <- append(list.b.t, foo)
    i = i + 1
  }

  i <- 1
  iterator <- n.Vecrors + 1
  list.b.p <- list()
  while (i <= iterator) {
    foo <- 2*(1 - pt(abs(unlist(list.b.t[i])), df=n - n.Vecrors -1))
    list.b.p <- append(list.b.p, foo)
    i = i + 1
  }

  r2 <- 1 - (sum(resd^2)) / sum((y - mean(y))^2)
  r2.adj <- 1 - ((1 - r2) * (n - 1)) / (n - n.Vecrors -1)
  rsquare <- paste('Multiple R-squared: ', round(r2, 4), ', Adjusted R-squared: ', round(r2.adj, 4))

  coeffs <- data.frame(cbind(c(bALS.Vector), c(list.b.error), c(list.b.t), c(list.b.p)))
  colnames(coeffs) <- c('Estimate', 'Std. Error', 't value', 'Pr(>|t|)')

  regres <- list('Residuals'=residual, 'Coefficients'=coeffs, resdi, rsquare, f.stat)

  if (ForPredict == TRUE) {
    estimate <- data.frame(cbind(bALS.Vector))
    colnames(estimate) <- c('Estimate')
    regres <- append(regres, estimate)

    MSres <- data.frame(cbind(c(msr)))
    colnames(MSres) <- c('MSres')
    regres <- append(regres, MSres)

    matrixX <- list(matrix.X)
    regres <- append(regres, matrixX)
  }
  print(regres)
  return(regres)
}
kukush.lm(y, xi, NULL)
