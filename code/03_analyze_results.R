#### PAUL BOCHTLER 
#### 12.12.2021

#-----------------------------------------#
#### SET ENVIRONMENT                   ####
#-----------------------------------------#

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

## empty potential rests from other scripts 
rm(list = ls())

## load packages and install missing packages 
require("pacman")
## define libraries to be loaded
packs <- c('tidyverse', "janitor", 'openxlsx', 
           'pdftools', 'purrr',
           'quanteda.textstats','quanteda','word2vec','tabulizer','datatable')

p_load(char = packs)


fdp_matrix <- readr::read_csv('../results/matrix_fdp.csv')
spd_matrix <- readr::read_csv('../results/matrix_spd.csv')
gruene_matrix <- readr::read_csv('../results/matrix_gruene.csv')

fdp_data <- readr::read_csv('../results/data_fdp.csv')
coal_data <- readr::read_csv('../results/data_coal.csv') %>% select(index_coal = index_party, sent)
gruene_data <- readr::read_csv('../results/data_gruene.csv')
spd_data <- readr::read_csv('../results/data_spd.csv')

fdp_long <- fdp_matrix %>% 
  select(-X1) %>%
  pivot_longer(cols = c(-index_party),names_to = 'index_coal') %>%
  group_by(index_coal) %>%
  slice_max(n = 3, order_by = value) %>%
  mutate(index_coal = as.numeric(index_coal)) %>%
  ungroup() %>%
  left_join(coal_data %>% rename(sent_coal = sent), by = 'index_coal') %>%
  left_join(fdp_data %>% rename(sent_party = sent), by = 'index_party') %>% 
  mutate(party = "FDP")

spd_long <- spd_matrix %>% 
  select(-X1) %>%
  pivot_longer(cols = c(-index_party),names_to = 'index_coal') %>%
  group_by(index_coal) %>%
  slice_max(n = 3, order_by = value)  %>%
  mutate(index_coal = as.numeric(index_coal)) %>%
  ungroup() %>%
  left_join(coal_data %>% rename(sent_coal = sent), by = 'index_coal') %>%
  left_join(spd_data %>% rename(sent_party = sent), by = 'index_party')%>% 
  mutate(party = "SPD")


gruene_long <- gruene_matrix %>% 
  select(-X1) %>%
  pivot_longer(cols = c(-index_party),names_to = 'index_coal') %>%
  group_by(index_coal) %>%
  slice_max(n = 3, order_by = value) %>%
  mutate(index_coal = as.numeric(index_coal)) %>%
  ungroup() %>%
  left_join(coal_data %>% rename(sent_coal = sent), by = 'index_coal') %>%
  left_join(gruene_data %>% rename(sent_party = sent), by = 'index_party') %>% 
  mutate(party = "Grüne")

full_top3 <- bind_rows(fdp_long, gruene_long, spd_long) %>% arrange( desc(value)) %>%
  filter(!sent_party =='.')

full_top90 <-full_top3 %>%
  filter(value >= .8)

count(full_top90,party)

datatable::DT(full_top3)
