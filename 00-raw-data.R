
# All data sets come from this website:
# https://www.datafiles.samhsa.gov/study-series/national-survey-drug-use-and-health-nsduh-nid13517

# The idea is to produce a many datasets that have two columns for drug and
# year, and several columns that contain a sort of demographic profile for each
# drug.

library(tidyverse)

## get location of each dataset within each year
datasets <- dir("raw_data", full.names = TRUE) %>% 
  map(dir, pattern = "\\.dta$|\\.DTA$", full.names = TRUE)

waves_df <- tibble(year = dir("raw_data"), datasets) %>% 
  unnest(datasets)


library(haven) ## all datasets are in STATA format and have "labelled" format

df <- read_dta(waves_df$datasets[[35]], n_max = 500)

df
