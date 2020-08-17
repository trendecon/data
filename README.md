
<!-- README.md is generated from README.Rmd. Please edit that file -->

# trendEcon data repository

We construct economic indicators for Switzerland, based on Google Trends
data.

The data is displayed and described at: <https://www.trendecon.org>

The data is stored as CSV in the
[`data`](https://github.com/trendecon/data/tree/master/data) folder.

### Example

The following R code download and displays the main indicator for CH,
DE, ant AT:

``` r

data <- read.csv("https://raw.githubusercontent.com/trendecon/data/master/data/ch/trendecon_sa.csv")
tsbox::ts_plot(data, title = "Switzerland")
```

![](README_files/figure-gfm/example-1.png)<!-- -->

``` r

data <- read.csv("https://raw.githubusercontent.com/trendecon/data/master/data/de/trendecon_sa.csv")
tsbox::ts_plot(data, title = "Germany")
```

![](README_files/figure-gfm/example-2.png)<!-- -->

``` r

data <- read.csv("https://raw.githubusercontent.com/trendecon/data/master/data/at/trendecon_sa.csv")
tsbox::ts_plot(data, title = "Austria")
```

![](README_files/figure-gfm/example-3.png)<!-- -->
