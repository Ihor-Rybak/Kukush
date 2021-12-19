predict <- function(regres, newdata, interval= 'None') {
  estimate <- unlist(regres$Estimate)
  MSres <- unlist(regres$MSres)

  n.estimate <- length(estimate)
  n.col.data <- ncol(newdata)
  n.row.data <- nrow(newdata)

  if (n.col.data < (n.estimate - 1)) {
    stop('The number of columns in the date is less than required')
  } else {
    #If the number of vectors x is greater than the number of elements of the vector estimate,
    #then we take the first n columns with yes

    list.x <- as.matrix(newdata[,1:n.estimate - 1])
  }

  data <- list(rep(1L, n.row.data), list.x)
  matrix.x0 <- as.matrix(matrix(unlist(data), ncol = n.estimate))
  matrix.x <- as.matrix(matrix(unlist(regres[8]), ncol = n.estimate))
  matrix.x.T <- t(matrix.x)

  fitted <- matrix.x0 %*% estimate

  df <- n.row.data - n.estimate
  t.crit <- abs(qt(0.05/2, df))

  if (interval == 'confidence') {
    i <- 1
    iterator <- n.row.data
    lwr <- list()
    upr <- list()
    while (i <= iterator) {
      library(expm)
      matrix.x0.T <- t(matrix.x0[i,])

      s.e. <- sqrtm(MSres * (matrix.x0.T %*% inv(matrix.x.T %*% matrix.x) %*% matrix.x0[i,]))

      foo <- fitted[i] - (t.crit * s.e.)
      bar <- fitted[i] + (t.crit * s.e.)
      lwr <- append(lwr, foo)
      upr <- append(upr, bar)
      i = i + 1
    }

    result <- data.frame(cbind(c(fitted), c(lwr), c(upr)))
    colnames(result) <- c('fit', 'lwr', 'upr')

    print(result)
    return(result)
  }

  if (interval == 'prediction') {
    i <- 1
    iterator <- n.row.data
    lwr <- list()
    upr <- list()
    while (i <= iterator) {
      library(expm)
      matrix.x0.T <- t(matrix.x0[i,])

      s.e. <- sqrtm(MSres * (matrix.x0.T %*% inv(1 + matrix.x.T %*% matrix.x) %*% matrix.x0[i,]))

      foo <- fitted[i] - (t.crit * s.e.)
      bar <- fitted[i] + (t.crit * s.e.)
      lwr <- append(lwr, foo)
      upr <- append(upr, bar)
      i = i + 1
    }

    result <- data.frame(cbind(c(fitted), c(lwr), c(upr)))
    colnames(result) <- c('fit', 'lwr', 'upr')

    return(result)
  }


  return(fitted)
}

predict(model, bloodpressure, 'confidence')

