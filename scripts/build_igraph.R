library(igraph)
library(tidyverse)
library(rtweet)

edge_list <- read_csv2("data/edge_list.csv")
d_full_information <- read_csv2("data/meps_full_list.csv")
d_mep_twitter <- read_csv2("data/meps_twitter.csv")

d_mep_twitter_adj <- d_mep_twitter %>% 
  filter(twitter_id %in% edge_list$user_id) %>% 
  filter(!(twitter_id %in% c(981468706302758912,1250119759)))

edge_list <- edge_list %>% 
  filter(!(user %in% c(981468706302758912,1250119759)))

net_igraph <- igraph::graph_from_data_frame(d = edge_list, directed = TRUE)

vertex_info <- V(net_igraph)$name %>% 
  tbl_df() %>%
  mutate(value = as.numeric(value)) %>% 
  left_join(.,d_mep_twitter_adj, by = c("value" = "twitter_id")) %>% 
  mutate(groupshort = case_when(group == "Group of the European People's Party (Christian Democrats)" ~ "EPP",
                                group == "Non-attached Members" ~ "NI",
                                group == "Identity and Democracy Group" ~ "ID",
                                group == "Group of the Progressive Alliance of Socialists and Democrats in the European Parliament" ~ "S&D",
                                group == "Group of the Greens/European Free Alliance" ~ "Greens/EFA",
                                group == "Confederal Group of the European United Left - Nordic Green Left" ~ "GUE/NGL",
                                group == "Renew Europe Group" ~ "Renew",
                                group == "European Conservatives and Reformists Group" ~ "ECR"),
         color = case_when(groupshort == "EPP" ~ "#3399FF", 
                           groupshort == "S&D" ~ "#FF0000",
                           groupshort == "ECR" ~ "#0000FF",
                           groupshort == "Renew" ~ "yellow",
                           groupshort == "GUE/NGL" ~ "#990000",
                           groupshort == "Greens/EFA" ~ "#009900",
                           groupshort == "ID" ~ "#2B3856",
                           groupshort == "NI" ~ "#999999"),
         shape = case_when(groupshort == "EPP" ~ "circle", 
                           groupshort == "S&D" ~ "square",
                           groupshort == "ECR" ~ "circle",
                           groupshort == "Renew" ~ "square",
                           groupshort == "GUE/NGL" ~ "star",
                           groupshort == "Greens/EFA" ~ "triangle",
                           groupshort == "ID" ~ "triangle",
                           groupshort == "NI" ~ "star"),
         colorpub = case_when(groupshort == "EPP" ~ "black", 
                              groupshort == "S&D" ~ "gray",
                              groupshort == "ECR" ~ "black",
                              groupshort == "Renew" ~ "gray",
                              groupshort == "GUE/NGL" ~ "black",
                              groupshort == "Greens/EFA" ~ "gray",
                              groupshort == "ID" ~ "black",
                              groupshort == "NI" ~ "gray"))


net_igraph <- set_vertex_attr(graph = net_igraph, name = "fullName", value = vertex_info$name)
net_igraph <- set_vertex_attr(graph = net_igraph, name = "GroupLong", value = vertex_info$group)
net_igraph <- set_vertex_attr(graph = net_igraph, name = "country", value = vertex_info$country)
net_igraph <- set_vertex_attr(graph = net_igraph, name = "nationalParty", value = vertex_info$natparty)
net_igraph <- set_vertex_attr(graph = net_igraph, name = "GroupShort", value = vertex_info$groupshort)
#net_igraph <- set_vertex_attr(graph = net_igraph, name = "color", value = vertex_info$color)
#net_igraph <- set_vertex_attr(graph = net_igraph, name = "shape", value = vertex_info$shape)
net_igraph <- set_vertex_attr(graph = net_igraph, name = "color", value = vertex_info$colorpub)


V(net_igraph)$label <- NA 
E(net_igraph)$width <- 0.1
E(net_igraph)$arrow.mode <- 0
V(net_igraph)$size <- 3

set.seed(1904)
plot.igraph(net_igraph)

