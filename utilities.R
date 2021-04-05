
# Re do the _utilities file for it to work with the new workflow


check_length <- function(...) {
  
  dfs <- list(...)
  var_names <- dfs %>% map(colnames) %>% reduce(intersect)
  
  if (!all(c("id", "coder") %in% var_names) | length(dfs) < 2) {
    stop(call. = FALSE, "This function expects two or more data frames with columns <<id>> and <<coder>>")
  }
  
  id_intersect <- map(dfs, pluck, "id") %>% reduce(intersect)
  id_union <- map(dfs, pluck, "id") %>% reduce(union)
  
  diffs <- map(dfs, ~ setdiff(id_union, .x$id))
  names(diffs) <- map(dfs, ~ unique(pluck(.x, "coder")))

  out <- bind_rows(dfs) %>% 
    filter(id %in% id_intersect) %>% 
    count(id, coder) %>% 
    pivot_wider(names_from = "coder", values_from = "n") 
  
  index <- out[, -1] %>% reduce(`==`)
  
  ok <- out %>% 
    split(out$id) %>%
    map(~ select(.x, !id) %>% unlist()) %>% 
    map_lgl(~ length(unique(.x)) == 1)
  
  list(
    agreement = scales::percent(mean(ok)),
    disagreements = out[!ok, ],
    not_coded = diffs
  )
  
}


agreement <- function(df, x) {
  
  if (!all(c("id", "coder") %in% colnames(df))) {
    stop(call. = FALSE, "This function expects one merged data frame with columns <<id>> and <<coder>>")
  }
  
  out <- df %>% 
    arrange(coder, id) %>% 
    mutate_if(is.character, factor) %>% 
    group_by(coder) %>% 
    group_split()
  
  names(out) <- out %>% map(pluck, "coder") %>% map_chr(~ unique(as.character(.x))) 
  
  arr_list <- list(
    make_table(x, out$aly, out$andres, "aly", "andres"),
    make_table(x, out$aly, out$lindsay, "aly", "lindsay"),
    make_table(x, out$lindsay, out$andres, "lindsay", "andres")
  )
  
  comparison <- map_chr(arr_list, ~ dimnames(.x) %>% names() %>% paste0(collapse = "-"))
  agreement <- arr_list %>% map_dbl( ~ sum(diag(.x)) / sum(.x) ) %>% scales::percent()
  
  num <- arr_list %>% map(diag) %>% map_dbl(sum) %>% sum()
  denom <- arr_list %>% map_dbl(sum) %>% sum()
  
  list(
    variable = x,
    overall_agreement = scales::percent(num / denom),
    agreements = tibble(comparison, agreement)
  )
  
}


make_table <- function(var_name, df1, df2, df1_name, df2_name) {

  id_intersect <- intersect(df1$id, df2$id)
  
  df1 <- df1 %>% filter(id %in% id_intersect)
  df2 <- df2 %>% filter(id %in% id_intersect)
  
  out <- table(df1[[var_name]], df2[[var_name]], useNA = "always")
  names(dimnames(out)) <- c(df1_name, df2_name)
  return(out)
  
}



check_disagreements <- function(x, y, var) {
  
  id_intersect <- intersect(x$id, y$id)
  
  out <- bind_rows(
    x %>% arrange(id) %>% filter(id %in% id_intersect) %>% select(id, coder, {{var}}) %>% mutate(i = row_number()),
    y %>% arrange(id) %>% filter(id %in% id_intersect) %>% select(id, coder, {{var}}) %>% mutate(i = row_number())
  ) %>% 
    pivot_wider(names_from = "coder", values_from = {{var}})
  
  ok <- out %>% 
    split(out$i) %>%
    map(~ select(.x, !c(id,i)) %>% unlist()) %>% 
    map_lgl(~ length(unique(.x)) == 1)
  
  out %>% 
    select(!i) %>% 
    filter(!ok)
}

