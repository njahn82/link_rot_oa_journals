library(tidyverse)
source("R/utils.R")
goaj <- readxl::read_xlsx("data/d18all_figshare.xlsx")
# check syntactial correctness, starts with either http or https
goaj_clean <- goaj %>%
  mutate(url_tidy = tolower(URL)) %>%
  filter(grepl("^(http|https)://", url_tidy))
# obtain url status code
purrr::map(goaj_clean$url_tidy, .f = purrr::safely(jn_status))
