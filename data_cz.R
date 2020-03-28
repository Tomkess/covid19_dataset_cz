library(rvest)
library(tidyjson)
library(dplyr)
library(data.table)

# ----- Get The Website -----
http_website <- 
  read_html(httr::GET("https://onemocneni-aktualne.mzcr.cz/covid-19"))

# ----- Get Table - Material Data -----
material_table <- html_nodes(http_website, "table")
material_data <- 
  html_table(material_table[4], fill = TRUE)[[1]] %>% 
  as.data.frame()

total_sex_data <- 
  html_table(material_table[3], fill = TRUE)[[1]] %>% 
  as.data.frame()

# ----- Foreign Countries Data -----
cumulative_persons_data <- 
  http_website %>% 
  html_nodes(xpath = '//*[@id="js-cummulative-total-persons-data"]') %>%
  html_attr(., "data-linechart") %>%
  as.tbl_json %>%
  spread_values(key = jstring("key"), color = jstring("color")) %>%
  enter_object("values") %>%
  gather_array %>%
  spread_values(date_at = jstring("x"), total_persons = jstring("y")) %>%
  select(date_at, total_persons) %>%
  mutate(date_at = lubridate::dmy(date_at)) %>%
  as.data.frame()

total_persons_data <- 
  http_website %>% 
  html_nodes(xpath = '//*[@id="js-total-persons-data"]') %>%
  html_attr(., "data-barchart") %>%
  as.tbl_json %>%
  spread_values(key = jstring("key"), color = jstring("color")) %>%
  enter_object("values") %>%
  gather_array %>%
  spread_values(date_at = jstring("x"), total_persons = jstring("y")) %>%
  select(date_at, total_persons) %>%
  mutate(date_at = lubridate::dmy(date_at)) %>%
  as.data.frame()

cumulative_tests_data <- 
  http_website %>% 
  html_nodes(xpath = '//*[@id="js-cummulative-total-tests-data"]') %>%
  html_attr(., "data-linechart") %>%
  as.tbl_json %>%
  spread_values(key = jstring("key"), color = jstring("color")) %>%
  enter_object("values") %>%
  gather_array %>%
  spread_values(date_at = jstring("x"), total_persons = jstring("y")) %>%
  select(date_at, total_persons) %>%
  mutate(date_at = lubridate::dmy(date_at)) %>%
  as.data.frame()

'js-cummulative-total-positive-table-data'
'js-cummulative-total-tests-table-data'

cumulative_total_positive_data <- 
  http_website %>% 
  html_nodes(xpath = '//*[@id="js-cummulative-total-positive-data"]') %>%
  html_attr(., "data-linechart") %>%
  as.tbl_json %>%
  spread_values(key = jstring("key"), color = jstring("color")) %>%
  enter_object("values") %>%
  gather_array %>%
  spread_values(date_at = jstring("x"), total_persons = jstring("y")) %>%
  select(date_at, total_persons) %>%
  mutate(date_at = lubridate::dmy(date_at)) %>%
  as.data.frame()

total_foreign_countries_data <- 
  http_website %>% 
  html_nodes(xpath = '//*[@id="js-total-foreign-countries-data"]') %>%
  html_attr(., "data-barchart") %>%
  as.tbl_json %>%
  spread_values(key = jstring("key"), color = jstring("color")) %>%
  enter_object("values") %>%
  gather_array %>%
  spread_values(country = jstring("x"), total_persons = jstring("y")) %>%
  select(country, total_persons) %>%
  as.data.frame()

total_regions_data <- 
  http_website %>% 
  html_nodes(xpath = '//*[@id="js-total-regions-data"]') %>%
  html_attr(., "data-barchart") %>%
  as.tbl_json %>%
  spread_values(key = jstring("key"), color = jstring("color")) %>%
  enter_object("values") %>%
  gather_array %>%
  spread_values(region = jstring("x"), total_persons = jstring("y")) %>%
  select(region, total_persons) %>%
  as.data.frame()

rm(material_table)
rm(http_website)

# ----- Saving the Results -----
write.table(x = cumulative_persons_data %>% as.data.frame(), 
            file = "cumu_persons_cz.csv", append = F, row.names = F)
write.table(x = cumulative_tests_data %>% as.data.frame(), 
            file = "cum_tests_cz.csv", append = F, row.names = F)
write.table(x = cumulative_total_positive_data %>% as.data.frame(), 
            file = "total_positive_cz.csv", append = F, row.names = F)
write.table(x = total_foreign_countries_data %>% as.data.frame(), 
            file = "foreign_countries_cz.csv", append = F, row.names = F)
write.table(x = total_persons_data %>% as.data.frame(), 
            file = "total_persons_cz.csv", append = F, row.names = F)
write.table(x = total_regions_data %>% as.data.frame(), 
            file = "regions_cz.csv", append = F, row.names = F)
write.table(x = total_sex_data %>% as.data.frame(), 
            file = "sex_age_cz.csv", append = F, row.names = F)
write.table(x = material_data %>% as.data.frame(), 
            file = "material_data_cz.csv", append = F, row.names = F)
