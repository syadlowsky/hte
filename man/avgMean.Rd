% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RFNode.R
\name{avgMean}
\alias{avgMean}
\title{avgMean}
\usage{
avgMean(x, y, y_sd = NULL)
}
\arguments{
\item{x}{A dataframe of observations in the current tree leaf}

\item{y}{A vector of outcomes in the current tree leaf}
}
\value{
The averaging metrics of the data
}
\description{
A default function to average the observations in each tree leaf
by taking the mean of the outcomes.
}
