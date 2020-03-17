library(rvest)
library(janitor)
library(tidyverse)

get_tornadoe_data <- function(year) {
  
  # build url
  base_url <- "http://www.tornadohistoryproject.com/tornado/Oklahoma/"
  url <- str_c(base_url, year, "/table")
  
  ok_tor <- read_html(url)
  
  # get entire table, look in Chrome Developer Tools for table ID
  ok_tor <- ok_tor %>% 
    html_nodes("#results") %>% 
    html_table() %>% 
    .[[1]]
  
  # extract names to set later
  ok_tor_names <- ok_tor[1, ]
  
  # remove rows that serve as headers
  ok_tor <- ok_tor %>% 
    slice(-seq(1, dim(ok_tor)[1], by = 10))
  
  names(ok_tor) <- ok_tor_names
  
  # clean up the data
  ok_tor <- clean_names(ok_tor) %>% 
    as_tibble() %>% 
    select(-(e:map_forum))
  
  ok_tor
}

years <- 1998:2017

ok_tornadoes <- map_dfr(years, get_tornadoe_data)

saveRDS(ok_tornadoes, file = "data/ok_tor.rds")

