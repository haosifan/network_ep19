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
