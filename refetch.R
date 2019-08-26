# refetch
library(tidyverse)
url_status_df <- readr::read_csv("data/jn_status.csv", col_names = FALSE)
url_status_df %>%
  count(X2, X3, X4)
jn_error <- readr::read_csv("data/error_log.csv", col_names = FALSE)
jn_https <- jn_error %>% 
  # obtain potential http / https problems
  filter(grepl("SSL", X1)) %>%
  mutate(url = gsub("http:", "https:", X2))
# refetch data
# 1. all non http non 200
non_200_links <- url_status_df %>%
  filter(!X4 == "Success: (200) OK") %>%
  .$X1
# 2. potenital https
jn_https_links <- jn_https$url
# 3. others
jn_https_links <- jn_error %>%
  filter(!X2 %in% jn_https$X2) %>%
  .$X2
miss_urls <- c(non_200_links, jn_https_links, jn_https_links)
jn_status_df <- plyr::llply(miss_urls, purrr::safely(jn_status_retry), 
                            .progress = "text")
error_msg <- purrr::map(jn_status_df, "error")
error_msg_character <- map_chr(error_msg, toString)
data_frame(error = error_msg_character, tidy_url = miss_urls) %>%
  filter(grepl("error", error, ignore.case = TRUE)) %>% 
  write_csv("data/error_log_2.csv")
