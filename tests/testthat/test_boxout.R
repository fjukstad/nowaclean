testdata <- matrix(c(rnorm(100*100, sd=2), rnorm(100*100, sd=5),
                  rnorm(100*100, sd=3), rnorm(100*100, sd=7)), nrow = 100)
rownames(testdata) <- as.character(1:nrow(testdata))
obj <- boxout(testdata)

test_that("boxout() throws error if no rownames exist", {
  d <- testdata
  rownames(d) <- NULL

  expect_error(boxout(d))
})

test_that("predict() returns character vector of rownames", {
  ret <- predict(obj)

  expect_is(ret, "character")
  expect_true(all(ret %in% rownames(testdata)))
})

test_that("boxout() returns object of boxout class", {
  expect_is(obj, "boxout")
})

test_that("boxout$statistics object contains quantiles, whiskers, and KS statistics", {
  # two whiskers, three quantiles, one KS statistic per row
  expect_equal(ncol(obj$statistics), 2+3+1)
  expect_equal(nrow(obj$statistics), nrow(testdata))
  expect_equal(colnames(obj$statistics), c("wl", "0.25", "0.5", "0.75", "wu", "ks"))
})

test_that("whiskers should be mostly outside of iqr", {
  s <- obj$statistics
  expect_true(all(s[, "wl"] <= s[, "0.25"]))
  expect_true(all(s[, "wu"] >= s[, "0.75"]))
})

test_that("there is some sort of plot function for boxout()", {
  pdf(file = NULL)
  plot(obj)
  dev.off()
})
