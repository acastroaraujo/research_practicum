
# install.packages("googlesheets4")
library(tidyverse)
library(googlesheets4)

url <- "https://docs.google.com/spreadsheets/d/1CUUyXMpQD2aTZdtgS7ah6nhIegPqRLEutIJgp0-vIYI/"

df <- read_sheet(ss = url, sheet = "andres_example") %>% 
  filter(!is.na(id)) #%>% 
  #filter(!maybe_exclude)

select_vars <- c("marijuana_role", "criminal_activity", "cjs_involvement", "med_involvement", "legal_controversy")


one <- df %>% 
  group_by(id) %>%
  count(type) %>% 
  pivot_wider(id, names_from = type, values_from = n, values_fill = list(n = 0), names_prefix = "n_")

two <- df %>% 
  group_by(id) %>% 
  summarize(across(select_vars, ~ sum(.x == "yes"))) 

three <- df %>% 
  group_by(id) %>% 
  count(marijuana_role) %>% 
  pivot_wider(id, names_from = marijuana_role, values_from = n, values_fill = list(n = 0), names_prefix = "marijuana_")

four <- df %>% 
  group_by(id) %>% 
  count(race_mention) %>% 
  mutate(race_mention = ifelse(is.na(race_mention), "no-race", race_mention)) %>% 
  pivot_wider(id, names_from = race_mention, values_from = n, values_fill = list(n = 0))

output <- list(one, two, three, four) %>% 
  reduce(full_join) 
  
output

sheet_write(output, url, sheet = "r_output")
