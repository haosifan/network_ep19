library(igraph)
library(tidyverse)


edge_list <- read_csv2("data/edge_list.csv")
d_full_information <- read_csv2("data/meps_full_list.csv")
d_mep_twitter <- read_csv2("data/meps_twitter.csv")

net_igraph <- igraph::graph_from_data_frame(d = edge_list, directed = TRUE)

net_igraph <- set_vertex_attr(graph = net_igraph, name = "fullName", value = d_full_information$name)
net_igraph <- set_vertex_attr(graph = net_igraph, name = "GroupLong", value = d_full_information$group)
net_igraph <- set_vertex_attr(graph = net_igraph, name = "country", value = d_full_information$country)
net_igraph <- set_vertex_attr(graph = net_igraph, name = "nationalParty", value = d_full_information$natparty)

