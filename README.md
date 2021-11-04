
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggsegCampbell <img src='man/figures/logo.png' align="right" height="138.5" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/ggseg/ggsegCampbell/workflows/R-CMD-check/badge.svg)](https://github.com/ggseg/ggsegCampbell/actions)
<!-- badges: end -->

This package contains dataset for plotting the Campbell 1905 historical
atlas with ggseg and ggseg3d, based on the supplementary materials of
Pijnenburg et al., NeuroImage, 239, 2021
[DOI](https://doi.org/10.1016/j.neuroimage.2021.118274); Version 1;
15-01-2021.

A.W. Campbell; Histological Studies On the Localisation of Cerebral
Function; University Press (1905)

To learn how to use these atlases, please look at the documentation for
[ggseg](https://ggseg.github.io/ggseg/) and
[ggseg3d](https://ggseg.github.io/ggseg3d)

## Installation

We recommend installing the ggseg-atlases through the ggseg
[r-universe](https://ggseg.r-universe.dev/ui#builds):

``` r
# Enable this universe
options(repos = c(
    ggseg = 'https://ggseg.r-universe.dev',
    CRAN = 'https://cloud.r-project.org'))

# Install some packages
install.packages('ggsegCampbell')
```

You can install the released version of ggsegCampbell from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("ggseg/ggsegCampbell")
```

``` r
library(ggseg)
#> Warning: package 'ggseg' was built under R version 4.1.1
#> Loading required package: ggplot2
library(ggseg3d)
library(ggsegCampbell)

plot(campbell) +
  theme(legend.position = "bottom", 
        legend.text = element_text(size = 9)) +
  guides(fill = guide_legend(ncol = 6))
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

``` r
library(dplyr)
ggseg3d(atlas = campbell_3d) %>% 
  add_glassbrain() %>% 
  pan_camera("right lateral")
```

<img src="man/figures/README-3d-plot.png" width="100%" />

Please note that the ‘ggsegCampbell’ project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to
this project, you agree to abide by its terms.
