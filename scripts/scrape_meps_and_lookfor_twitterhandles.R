library(tidyverse)
library(rvest)
library(rtweet)
library(openxlsx)

url <- "https://www.europarl.europa.eu/meps/en/full-list/xml"

xml_list <- read_html(url) %>% 
  html_nodes("mep") 


extract_meps <- function(liste) {
  name <- liste %>% html_node("fullname") %>% html_text()
  country <- liste %>% html_node("country") %>% html_text()
  politicalgroup <- liste %>% html_node("politicalgroup") %>% html_text()
  natgroup <- liste %>% html_node("nationalpoliticalgroup") %>% html_text()
  
bind_cols(list(name, country, politicalgroup, natgroup))  
}

meps_list <- lapply(xml_list, extract_meps) %>% bind_rows() %>% 
  rename(name = V1, country = V2, group = V3, natparty = V4)

i <- NULL
list_search <- NULL

for (i in 1:748) {
  list_search[[i]] <- try(search_users(meps_list$name[i], n = 1), silent = TRUE)
  if (class(list_search[[i]]) == "try-error") {list_search[[i]] <- NULL}
  cat(i, "von", dim(meps_list)[1])
}

names(list_search) <- meps_list$name[1:748]

twitter_maybes <- list_search %>% data.table::rbindlist(fill = TRUE, idcol = TRUE) %>% tbl_df()

meps_list <- left_join(meps_list, select(twitter_maybes, .id, screen_name), by = c("name" = ".id"))
write_excel_csv2(meps_list, path = "list_meps_2019.csv", na = "")



list_members_politico <- rtweet::lists_members(slug = "MEPs", owner_user = "POLITICOEurope")
write.xlsx(list_members_politico, "liste_politico.xlsx")

list_arne <- read.xlsx("list_meps_2019_arne414.xlsx", sheet = 1) %>% 
  tbl_df() %>%
  filter(row_number() %in% 414:748)

left_join(list_arne, list_members_politico, by = c("twitter_name" = "screen_name")) %>%
  mutate(checked = case_when(!is.na(user_id) ~ TRUE)) %>% 
  write.xlsx("Liste_ab414.xlsx")
  



