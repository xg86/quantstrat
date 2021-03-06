# A test for indicators, signals and rules using the macd demo
#
#

stopifnot(require(testthat))
stopifnot(require(quantstrat))
context("demo/test_maCross_stoptrailing.R")

devAskNewPage(ask = FALSE) # dont prompt for new page, mainly for R CMD check
source(paste0(path.package("quantstrat"),"/demo/maCross_stoptrailing.R")) # source demo

test_that("End.Equity equals 7809", {
  expect_equal(round(tradeStats('Port.Luxor','AAPL')$End.Equity), 2771)
})

test_that("num txns equals 11", { # note we pad the start with zeros
  expect_equal(nrow(getTxns('Port.Luxor','AAPL')), 11)
})

test_that("num orders equals 17", {
  expect_equal(nrow(obook$Port.Luxor$AAPL), 17)
})

test_that("sum closed order prices equals sum txn prices", {
  expect_equal(sum(as.numeric(getOrderBook("Port.Luxor")$Port.Luxor$AAPL$Order.Price[which(getOrderBook("Port.Luxor")$Port.Luxor$AAPL$Order.Status == "closed")])),
               sum(getTxns("Port.Luxor","AAPL")$Txn.Price))
})

test_that("stoptrailing trade prices equal 150.7013, 151.2416, 163.0308, 164.8702, 168.1434", {
  expect_equal(round(as.numeric(getOrderBook("Port.Luxor")$Port.Luxor$AAPL$Order.Price[which(getOrderBook("Port.Luxor")$Port.Luxor$AAPL$Order.Status == "closed" & getOrderBook("Port.Luxor")$Port.Luxor$AAPL$Order.Type == "stoptrailing")]$Order.Price), 4),
               
               # 2017-08-02 00:00:00.00001 "150.70126151877" 
               # 2017-10-17 00:00:00.00001 "151.241571914452"
               # 2018-03-22 00:00:00.00009 "163.030760854114"
               # 2018-04-19 00:00:00.00009 "164.870181860637"
               # 2018-11-23 00:00:00.00009 "168.14344619348"
               
               c(150.7013, 151.2416, 163.0308, 164.8702, 168.1434))
})
       
# Commands for running this test file from the console if required:
#
# require(testthat)
# test_file("~/quantstrat/tests/testthat/test_demo_maCross_stoptrailing.R")
