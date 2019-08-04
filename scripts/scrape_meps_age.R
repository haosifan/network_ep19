library(tidyverse)
library(rvest)
library(lubridate)
library(ggmap)

url <- "http://www.europarl.europa.eu/meps/en/full-list/all"


#links
links_lv0 <- read_html(url) %>% 
  html_nodes(".single-member-container") %>% 
  html_children() %>% 
  html_children() %>% 
  html_attr("href") %>% 
  paste0("http://www.europarl.europa.eu",.)

#names

names_lv0 <- read_html(url) %>% 
  html_nodes(".single-member-container") %>% 
  html_children() %>% 
  html_children() %>% 
  html_attr("title")

lv0_list <- bind_cols(links = links_lv0, names = names_lv0)

scrape_age <- function(link) {
  country <- read_html(link) %>% html_node("#erpl-member-country-name") %>% html_text()
  birthdate <- read_html(link) %>% html_node("#birthDate") %>% html_text()
  birthplace <- read_html(link) %>% html_node("#birthPlace") %>% html_text()
  
  res_mepinfo <- bind_cols(country = country, birthdate = birthdate, birthplace = birthplace)
  return(res_mepinfo)
}

mepinfo_raw <- plyr::ldply(links_lv0, scrape_age, .progress = "text")
