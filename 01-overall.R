
# To do:
# 1. Figure out the weights
# 2. Demographics


# Set up ------------------------------------------------------------------

library(tidyverse)
theme_set(
  theme_minimal(base_family = "Avenir Next Condensed", base_line_size = 0) +
    theme(plot.title = element_text(face = "bold", size = 16))
)

coverage <- read_rds("coverage.rds") %>% 
  filter(n >= 16)

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
    col_select = any_of(c(coverage$var, str_to_upper(coverage$var)))
  )
  
  colnames(df) <- str_to_lower(colnames(df))
  
  out <- df %>% 
    select(any_of(coverage$var)) %>% 
    haven::zap_labels() %>% 
    pivot_longer(cols = everything(), names_to = "var", values_to = "x") %>% 
    group_by(var) %>% 
    summarize(prop = mean(x), n = sum(x)) %>% 
    left_join(distinct(coverage, var, description)) %>% 
    mutate(year = waves_df$year[[i]])
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
  filter(!str_detect(description, "ALCOHOL|CIGARETTES|MARIJUANA|PSYCHOTHERAPEUTICS|STIMULANTS|TRANQUILIZERS|SNUFF")) %>% ## REMOVE ALCOHOL
  mutate(description = factor(description) %>% fct_rev()) %>%
  ggplot(aes(factor(year), description, fill = prop)) + 
  geom_tile(color = "white") +
  scale_x_discrete(guide = guide_axis(angle = 90)) + 
  labs(x = NULL, y = NULL, title = "NSDUH Usage", 
       fill = NULL, 
       subtitle = 'questions related to "past year use"') +
  scale_fill_viridis_c(
    na.value = "grey90", labels = scales::percent_format(1), 
    option = "magma", direction = -1) +
  theme(legend.position = "bottom",
        legend.key.width = unit(0.1,"npc")) 


df %>% 
  #filter(!str_detect(description, "ALCOHOL|CIGARETTES|MARIJUANA|PSYCHOTHERAPEUTICS|ANALGESICS")) %>% ## REMOVE ALCOHOL
  mutate(description = factor(description) %>% fct_rev()) %>%
  ggplot(aes(factor(year), description, fill = log(n))) + 
  geom_tile(color = "white") +
  scale_x_discrete(guide = guide_axis(angle = 90)) + 
  scale_fill_viridis_c(option = "magma", direction = -1, na.value = "grey90") +
  labs(x = NULL, y = NULL, title = "NSDUH Usage", 
       fill = "log(n)", 
       subtitle = 'questions related to "past year use"') +
  theme(legend.position = "bottom",
        legend.key.width = unit(0.09,"npc")) 

ggsave("nsduh_counts.png", device = "png", dpi = "print",
       width = 10, height = 6)


df %>% 
  filter(str_detect(description, "ALCOHOL|MARIJUANA|CIGARETTES")) %>% ## REMOVE ALCOHOL 
  mutate(description = factor(description) %>% fct_rev()) %>% 
  mutate(se = sqrt(prop * (1- prop) / n),
         lower = prop + se * qnorm(0.025),
         upper = prop + se * qnorm(0.975)) %>% 
  mutate(lower = ifelse(lower <= 0, 0, lower),
         upper = ifelse(upper >= 1, 1, upper)) %>% 
  drop_na() %>% 
  ggplot(aes(year, prop)) +
  geom_pointrange(aes(ymin = lower, ymax = upper), size = 1/10) +
  geom_ribbon(aes(ymin = lower, ymax = upper, group = description, fill = description), alpha = 1/2) +
  geom_line(aes(group = description, color = description)) +
  labs(x = NULL, y = NULL, title = "Past Year Use", fill = NULL, color = NULL) +
  scale_y_continuous(labels = scales::percent_format(1)) + 
  theme_minimal(base_family = "Avenir Next Condensed") +
  theme(legend.position = "top",
        plot.title = element_text(face = "bold", size = 16)) 

ggsave("nsduh_popular_drugs.png", device = "png", dpi = "print",
       width = 10, height = 6)
