## network graph publication ready

library(visNetwork)
library(igraph)

source("scripts/build_igraph.R")

net_igraph <- delete_vertex_attr(net_igraph, "color")
#delete_vertex_attr(net_igraph, "shape")

#net_igraph <- set_vertex_attr(graph = net_igraph, name = "shape", value = vertex_info$shape)
net_igraph <- set_vertex_attr(graph = net_igraph, name = "group", value = V(net_igraph)$GroupShort)
#net_igraph <- set_vertex_attr(graph = net_igraph, name = "color", value = vertex_info$colorpub)

legendNodes <- data.frame(
  label = c("ID", "ECR", "EPP","Renew","S&D","Greens/EFA","GUE/NGL","NI"),
  color = c("black","black","black","black","gray","gray","gray","gray"),
  shape = c("dot","square","triangle","diamond","dot","square","triangle","diamond")
)


vis_graph <- visIgraph(net_igraph, idToLabel = FALSE) %>% 
  visEdges(arrows = "none", hidden = TRUE) %>% 
  visNodes(value = 20) %>% 
  visGroups(groupname = "ID", color = "black", shape = "dot") %>% 
  visGroups(groupname = "ECR", color = "black", shape = "square") %>% 
  visGroups(groupname = "EPP", color = "black", shape = "triangle") %>% 
  visGroups(groupname = "Renew", color = "black", shape = "diamond") %>% 
  visGroups(groupname = "S&D", color = "gray", shape = "dot") %>% 
  visGroups(groupname = "Greens/EFA", color = "gray", shape = "square") %>% 
  visGroups(groupname = "GUE/NGL", color = "gray", shape = "triangle") %>% 
  visGroups(groupname = "NI", color = "gray", shape = "diamond") %>% 
  visLegend(position = "right", addNodes = legendNodes, useGroups = FALSE)

vis_graph

visExport(vis_graph, type = "jpeg", name = "network_complete")


## Coloured publication

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
                           groupshort == "NI" ~ "#999999"))


net_igraph <- set_vertex_attr(graph = net_igraph, name = "fullName", value = vertex_info$name)
net_igraph <- set_vertex_attr(graph = net_igraph, name = "GroupLong", value = vertex_info$group)
net_igraph <- set_vertex_attr(graph = net_igraph, name = "country", value = vertex_info$country)
net_igraph <- set_vertex_attr(graph = net_igraph, name = "nationalParty", value = vertex_info$natparty)
net_igraph <- set_vertex_attr(graph = net_igraph, name = "GroupShort", value = vertex_info$groupshort)
net_igraph <- set_vertex_attr(graph = net_igraph, name = "color", value = vertex_info$color)

visIgraph(net_igraph, idToLabel = FALSE, randomSeed = 1913) %>% 
  visEdges(arrows = "none", hidden = FALSE) %>% 
  visNodes(value = 20)


library(threejs)
library(htmlwidgets)


graphjs(net_igraph, showLabels=TRUE, bg = "white")
