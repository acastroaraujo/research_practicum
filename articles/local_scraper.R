library(rvest)
library(tidyverse)


local_scrape <- function(x) {
  
  website <- read_html(x) 
  
  title <- website %>% 
    html_nodes(".css-2fgx4k") %>% 
    html_text()
  
  time <- website %>% 
    html_nodes(".css-17ubb9w") %>% 
    html_text() %>% 
    lubridate::mdy()
  
  url <- website %>% 
    html_nodes(".css-1i8vfl5 a") %>% 
    html_attr("href")
  
  out <- tibble(date = time, title, url)
  
  return(out)
  
}



## write to google sheets

library(googlesheets4)

url <- "https://docs.google.com/spreadsheets/d/1CUUyXMpQD2aTZdtgS7ah6nhIegPqRLEutIJgp0-vIYI/"

## 1990-1995 (downloaded manually after clicking)

out <- local_scrape("articles/NYT-1990-1995.html")

set.seed(12345)
s <- sample(out$url, size = 5)

out %>% 
  arrange(date) %>% 
  mutate(testing = url %in% s) %>%
  sheet_write(url, sheet = "1990-1995")


## 2015-2020 (downloaded manually after clicking)

out <- local_scrape("articles/NYT-2015-2020.html")

set.seed(12345)
s <- sample(out$url, size = 5)

out %>% 
  arrange(date) %>% 
  mutate(testing = url %in% s) %>% 
  sheet_write(url, sheet = "2015-2020")

