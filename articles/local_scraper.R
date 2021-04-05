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
s <- sample(out$url, size = 5)     ## first sample
s2 <- sample(out$url, size = 5)    ## second sample

out1 <- out %>% 
  arrange(date) %>% 
  mutate(id = paste0("A", row_number())) %>% 
  mutate(testing = url %in% c(s, s2)) %>% 
  select(id, everything())

#sheet_write(out1, url, sheet = "1990-1995")

out_third <- out1 %>% 
  filter(!url %in% c(s, s2)) %>% 
  sample_n(15) %>% 
  select(!testing)

out_third$medicalization <- NA
out_third$decriminalization <- NA
out_third$legal_controversy <- NA
out_third$criminalization <- NA


## 2015-2020 (downloaded manually after clicking)

out <- local_scrape("articles/NYT-2015-2020.html")

set.seed(12345)
s <- sample(out$url, size = 5)
s2 <- sample(out$url, size = 5)    ## second sample

out2 <- out %>% 
  arrange(date) %>% 
  mutate(id = paste0("B", row_number())) %>% 
  mutate(testing = url %in% c(s, s2)) %>% 
  select(id, everything())

#sheet_write(out2, url, sheet = "2015-2020")

out_third2 <- out2 %>% 
  filter(!url %in% c(s, s2)) %>% 
  sample_n(15) %>% 
  select(!testing)

bind_rows(out_third, out_third2) %>% 
  mutate(included = NA) %>% 
  select(id, date, title, url, included, everything()) %>% 
  sheet_write(url, sheet = "aly_data")

bind_rows(out_third, out_third2) %>% 
  mutate(included = NA) %>% 
  select(id, date, title, url, included, everything()) %>% 
  sheet_write(url, sheet = "andres_data")

bind_rows(out_third, out_third2) %>% 
  mutate(included = NA) %>% 
  select(id, date, title, url, included, everything()) %>% 
  #sheet_write(url, sheet = "lindsay_data")



bind_rows(out1, out2) %>% 
  mutate(year = lubridate::year(date)) %>% 
  ggplot(aes(year)) + geom_bar(color = "white", fill = "steelblue1") + 
  theme_minimal(base_family = "Avenir Next Condensed") + 
  theme(plot.title = element_text(face = "bold", size = 16)) +
  labs(x = NULL, title = "Sampling Frame")

ggsave("sampling_frame.png", device = "png", width = 10, height = 5)


samples <- read_sheet(ss = url, sheet = "andres_data") %>% 
  filter(!is.na(id)) %>% 
  pull(id)

samples


out2 <- out2 %>% 
  filter(!id %in% samples) %>% 
  sample_n(20)

out1 <- out1 %>% 
  filter(!id %in% samples) %>% 
  sample_n(20)




out_april_4 <- bind_rows(out1, out2) %>% 
  mutate(included = NA) %>% 
  select(id, date, title, url) 



#write_sheet(out_april_4, ss = url, sheet = "sample_april_4")



andres_data <- read_sheet(ss = url, sheet = "andres_data")



