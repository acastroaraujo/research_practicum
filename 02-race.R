
# Set up ------------------------------------------------------------------

library(tidyverse)
theme_set(
  theme_minimal(base_family = "Avenir Next Condensed", base_line_size = 0) +
    theme(plot.title = element_text(face = "bold", size = 16))
)

drug_coverage <- read_rds("coverage.rds") %>% 
  filter(n >= 16)

race_coverage <- read_rds("race_coverage.rds")

# Raw Data

library(haven) ## all datasets are in STATA format and have "labelled" format

datasets <- dir("raw_data", full.names = TRUE) %>% 
  map(dir, pattern = "\\.dta$|\\.DTA$", full.names = TRUE)

waves_df <- tibble(year = as.integer(dir("raw_data")), datasets) %>% 
  unnest(datasets) %>% 
  arrange(desc(datasets))

# Functions ---------------------------------------------------------------

extract_all_props <- function(i) {
  
  df <- read_dta(
    file = waves_df$datasets[[i]], 
    col_select = any_of(c(drug_coverage$var, str_to_upper(drug_coverage$var),
                          race_coverage$var, str_to_upper(race_coverage$var)))
  )
  
  colnames(df) <- str_to_lower(colnames(df))
  
  out <- df %>% 
    select(any_of(c(drug_coverage$var, race_coverage$var))) %>% 
    haven::zap_labels() 
  
  race_var <- colnames(out)[colnames(out) %in% race_coverage$var]
  
  out$race <- label_race(out[[race_var]], race_var)
  
  out %>% 
    pivot_longer(cols = any_of(drug_coverage$var), names_to = "var", values_to = "x") %>% 
    group_by(race, var) %>% 
    summarize(prop = mean(x), n = sum(x)) %>% 
    left_join(distinct(drug_coverage, var, description)) %>% 
    mutate(year = waves_df$year[[i]]) %>% 
    pivot_wider(names_from = "race", values_from = c("prop", "n"))
}

label_race <- function(x, var) {
  
  switch(var,
    "newrace2" = ifelse(x == 1, "white", "other"),
    "irracex" = ifelse(x == 5, "white", "other"),
    "irrace" = ifelse(x == 4, "white", "other")
    )
  
}


# Extract all proportions -------------------------------------------------

output <- vector("list", length = nrow(waves_df))

for (i in seq_along(output)) {
  output[[i]] <- extract_all_props(i)
}

output[[27]] <- NULL

df <- bind_rows(output) %>% 
  complete(year = 1979:2019) %>% 
  complete(year, description, fill = list(x = NA)) %>% 
  filter(!is.na(description)) 

df %>% 
  mutate(odds = prop_other / prop_white) %>% 
  mutate(description = factor(description) %>% fct_rev()) %>%
  ggplot(aes(factor(year), description, fill = log(odds))) + 
  geom_tile(color = "white") +
  scale_x_discrete(guide = guide_axis(angle = 90)) + 
  scale_fill_gradient2(midpoint = 0, low = "red", mid = "white", high = "purple", na.value = "grey90") +
  labs(x = NULL, y = NULL, title = "NSDUH Usage, by \"race\"", 
       fill = "log(prop_other / \nprop_white)", 
       subtitle = 'questions related to "past year use"') +
  theme(legend.position = "bottom",
        legend.key.width = unit(0.09,"npc")) 

ggsave("nsduh_race_drugs.png", device = "png", dpi = "print",
       width = 10, height = 6)
