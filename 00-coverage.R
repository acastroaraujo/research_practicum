
# All data sets come from this website:
# https://www.datafiles.samhsa.gov/study-series/national-survey-drug-use-and-health-nsduh-nid13517

# The idea is to produce a many datasets that have two columns for drug and
# year, and several columns that contain a sort of demographic profile for each
# drug.


# Set up ------------------------------------------------------------------


library(tidyverse)
theme_set(
  theme_minimal(base_family = "Avenir Next Condensed", base_line_size = 0) +
    theme(plot.title = element_text(face = "bold", size = 16))
  )

library(haven) ## all datasets are in STATA format and have "labelled" format

## get location of each dataset within each year
datasets <- dir("raw_data", full.names = TRUE) %>% 
  map(dir, pattern = "\\.dta$|\\.DTA$", full.names = TRUE)

waves_df <- tibble(year = as.integer(dir("raw_data")), datasets) %>% 
  unnest(datasets) %>% 
  arrange(desc(datasets))

# Functions ---------------------------------------------------------------

extract_past_year_vars <- function(x, N = 10) {
  
df <- read_dta(waves_df$datasets[[x]], n_max = N)
  
  dict <- tibble(
    var = names(df),
    description = seq_along(df) %>% map_chr(function(i) attr(df[[i]], "label"))
  ) %>% 
    filter(str_detect(description, "PAST YEAR USE"), 
           !str_detect(description, "ANY PAST YEAR USE"),
           !str_detect(description, "CIGARS|TOBACCO|ONLY"),
           !str_detect(description, "^CPN "),
           !str_detect(description, "ILLICIT DRUG")) %>% 
    mutate(year = waves_df$year[[x]]) %>% 
    mutate(var = str_to_lower(var)) 
  
  return(dict)
  
}

clean_past_year_description <- function(x) {
  
  x %>% 
    str_remove_all('\"|\'') %>% 
    str_remove("^RC- *") %>% 
    str_remove(" ?- ?.*USE$") %>% 
    str_remove("^ANY ")
}

extract_race_vars <- function(x, N = 10) {
  
  df <- read_dta(waves_df$datasets[[x]], n_max = N)
  
  dict <- tibble(
    var = names(df),
    description = seq_along(df) %>% map_chr(function(i) attr(df[[i]], "label"))
  ) %>% 
    filter(str_detect(description, "RACE")) %>% 
    mutate(year = waves_df$year[[x]]) %>% 
    mutate(var = str_to_lower(var)) %>% 
    filter(str_detect(var, "irrace|newrace2")) 
  
  return(dict)
  
}


# Extract all "PAST YEAR" variables ---------------------------------------

output <- vector("list", length = nrow(waves_df))

for (i in seq_along(output)) {
  output[[i]] <- extract_past_year_vars(i)
}

  
temp <- bind_rows(output) %>% 
  mutate(var = str_to_lower(var)) %>% 
  mutate(description = map_chr(description, clean_past_year_description)) %>%
  distinct(var, description) %>% 
  mutate(description = case_when(
    description == "PAIN RELIEVERS" ~ "ANALGESICS",
    description == "PAIN RELIEVER" ~ "ANALGESICS",
    description == "METHAMPHETAMINE" ~ "METHAMPHETAMINES",
    TRUE ~ description
  )) %>% 
  distinct(var, description) %>% 
  filter(var != "mthmon") ## mislabelled month as year
  
year_coverage <- bind_rows(output) %>% 
  mutate(var = str_to_lower(var)) %>% 
  filter(var != "mthmon") %>% 
  select(!description) %>% 
  left_join(temp) %>%
  distinct(var, year, description) %>% ## this removes repeated 1994 data
  add_count(description)

# Save to RDS file
write_rds(year_coverage, "coverage.rds", compress = "gz")

# Save to Excel file
year_coverage %>% 
  distinct(description, n) %>% 
  writexl::write_xlsx("nsduh_yr_coverage.xlsx")

df <- bind_rows(output) %>% 
  mutate(var = str_to_lower(var)) %>% 
  select(!description) %>%
  inner_join(filter(year_coverage, n >= 16)) %>% 
  distinct(description, year) %>% 
  add_count(description) 

df %>% 
  mutate(x = 1) %>% 
  pivot_wider(names_from = "year", values_from = "x", values_fill = 0) %>% 
  arrange(desc(n)) %>% 
  writexl::write_xlsx("nsduh_yr_drugs.xlsx")

df %>% 
  select(!n) %>% 
  mutate(x = TRUE) %>%
  complete(year = 1979:2019) %>% 
  complete(year, description, fill = list(x = NA)) %>% 
  filter(!is.na(description)) %>% 
  mutate(description = factor(description) %>% fct_rev()) %>% 
  ggplot(aes(factor(year), description, fill = x)) + 
  geom_tile(color = "white", show.legend = FALSE) +
  scale_x_discrete(guide = guide_axis(angle = 90)) + 
  scale_fill_manual(values = "steelblue1", na.value = "grey90") +
  labs(x = NULL, y = NULL, title = "NSDUH Coverage", 
       subtitle = 'questions related to "past year use"') 
  
ggsave("nsduh_coverage.png", device = "png", dpi = "print",
       width = 10, height = 5)



# Extract all RACE vars ---------------------------------------------------

output <- vector("list", length = nrow(waves_df))

for (i in seq_along(output)) {
  output[[i]] <- extract_race_vars(i)
}


write_rds(bind_rows(output), "race_coverage.rds", compress = "gz")




# Extract weights ---------------------------------------------------------

extract_weight <- function(x, N = 10) {
  
  df <- read_dta(waves_df$datasets[[x]], n_max = N)
  
  dict <- tibble(
    var = str_to_lower(names(df)),
    description = seq_along(df) %>% map_chr(function(i) attr(df[[i]], "label"))
  ) %>% 
    filter(var %in% c("analwt_c", "analwt")) %>% 
    mutate(year = waves_df$year[[x]]) 

  return(dict)  
}


output <- vector("list", length = nrow(waves_df))

for (i in seq_along(output)) {
  output[[i]] <- extract_weight(i)
}


write_rds(bind_rows(output), "weight_coverage.rds", compress = "gz")
