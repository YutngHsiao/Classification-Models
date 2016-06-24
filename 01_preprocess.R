sample <- preProcess(spambase[, -(ncol(spambase))], method=c("BoxCox", "center", "scale"))
transformed <- predict(sample, spambase[, -(ncol(spambase))])

nzv <- nearZeroVar(transformed, freqCut = 99/5, saveMetrics=TRUE)
transformed <- transformed[,nzv$nzv==FALSE]

correlations <- cor(transformed)

library(corrplot)
corrplot(correlations, method="number" ,type="lower")
highCorr <- findCorrelation(correlations, cutoff = .35)
filtered <- transformed[, -highCorr]

Target <- spambase$is_spam
final_sample <- cbind(filtered, Target)

### anotiher correlation test
cor.mtest <- function(mat, ...) {
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat<- matrix(NA, n, n)
  diag(p.mat) <- 0
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      tmp <- cor.test(mat[, i], mat[, j], ...)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
    }
  }
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  p.mat
}

cor_test2 <- cor.mtest(sample)



