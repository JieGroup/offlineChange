% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/change_detection_multi_window.R
\name{MultiWindow}
\alias{MultiWindow}
\title{Multi-window Change Points Detection}
\usage{
MultiWindow(y, window_list = c(100, 50, 20, 10, 5), point_max = 5,
  prior_range = NULL, get_mle = GetMle, penalty = "bic",
  seg_min = 1, num_init = NULL, tolerance = 1, cpp = TRUE,
  ret_score = FALSE)
}
\arguments{
\item{y}{The original data to find change points. Must be one dimensional
data}

\item{window_list}{The list of window sizes, must be in form
c(100,50,20,10,5), in descending order and each window_size > 2L. L is the
lag order of the dataset.}

\item{point_max}{The largest candidate number of change points.}

\item{prior_range}{The prior ranges that considered to contain change
points.Each prior range contains one change point. example:
prior_range=list(c(30,200),c(220,400))}

\item{get_mle}{The method used to transform dependent data to independent
data.}

\item{penalty}{Penalty type term. Default is "bic". Users can use other penalty term.}

\item{seg_min}{Minimal segment size, must be positive integer.}

\item{num_init}{The number of repetition times, in order to avoid local
minimal. Default is squared root of number of transformed data.}

\item{tolerance}{The tolerance level. The selected narrow ranges are with}

\item{cpp}{Logical value indicating whether to accelerate using rcpp. Default is TRUE.}

\item{ret_score}{Logical value indicating whether to return score. Default is FALSE.}
}
\value{
\item{n_peak_range}{The number of peak ranges.}
  \item{peak_ranges}{The location of peak ranges.}
  \item{score}{score matrix. (only when \emph{ret_score} is \emph{TRUE})}
}
\description{
Use a sequence of window sizes to capture ranges of change points.
}
\details{
Given time series data y1,y2...yN, a sequence of window sizes w1 > ... > wR
can be used to capture any true segment of small size. For each wr, the
original data is turned into a sequence of L + 1 dimensional data that can be
approximated as independent. Then the change points of independent data can
be detected by minimizing penalized quadratic loss. By further mapping these
change points back to the original scale, several short ranges (each of size
2wr) that probably contain the desired change points are obtained. After
repeating the above procedure for different wr, the detected ranges of change
points from each window size are scored by one. The scores are aggregated,
and the ranges with highest score or around the highest score (determined by
the tolerance parameter) are finally selected.
}
\examples{
N <- 1000
N1 <- floor(0.1*N)
N2 <- floor(0.3*N)
a1 <- c(0.8, -0.3); c1 <- 0
a2 <- c(-0.5, 0.1); c2 <- 0
a3 <- c(0.5, -0.5); c3 <- 0
y <- rep(0,N)
L<-2
y[1:L] <- rnorm(L)
for (n in (L+1):N){
  if (n <= N1) {
    y[n] <- y[(n-1):(n-L)] \%*\% a1 + c1 + rnorm(1)
  } else if (n <= (N1+N2)) {
    y[n] <- y[(n-1):(n-L)] \%*\% a2 + c2 + rnorm(1)
  }
  else {
    y[n] <- y[(n-1):(n-L)] \%*\% a3 + c3 + rnorm(1)
  }
}
MultiWindow(y,window_list=c(100,50,20,10,5),point_max=5)
MultiWindow(y,window_list=c(100,50,20,10,5),prior_range=list(c(30,200),c(220,400)))
}
\references{
J. Ding, Y. Xiang, L. Shen, and V. Tarokh, \emph{Multiple Change
  Point Analysis: Fast Implementation and Strong Consistency}. IEEE
  Transactions on Signal Processing, vol. 65, no. 17, pp. 4495-4510, 2017.
}
