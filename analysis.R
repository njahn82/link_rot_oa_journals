library(tidyverse)
source("R/utils.R")
goaj <- readxl::read_xlsx("data/d18all_figshare.xlsx")
# check syntactial correctness, starts with either http or https
goaj_clean <- goaj %>%
  mutate(url_tidy = tolower(URL)) %>%
  filter(grepl("^(http|https)://", url_tidy))
# obtain url status code running on parallel cores
jn_status_df <- plyr::llply(goaj_clean$url_tidy, purrr::safely(jn_status), 
                            .progress = "text")
error_msg <- purrr::map(jn_status_df, "error")
error_msg_character <- tibblemap_chr(error_msg, toString)
data_frame(error = error_msg_character, tidy_url = goaj_clean$url_tidy) %>%
  filter(grepl("error", error, ignore.case = TRUE)) %>%
  write_csv("data/error_log.csv")
