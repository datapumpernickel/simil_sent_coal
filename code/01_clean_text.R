#### PAUL BOCHTLER 
#### 11.12.2021

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
           'quanteda.textstats','quanteda','word2vec','tabulizer')

p_load(char = packs)

pdfs <- list.files('raw_data', full.names = T)

texts <-
  map_dfr(
    pdfs,
    ~ if (str_detect(.x, 'fdp'))
      tabulizer::extract_text(.x) %>% tibble(text = ., party = .x)
    else
      pdf_text(.x) %>% tibble(text = ., party = .x))

texts_clean <- texts %>%
  mutate(text = str_squish(text) %>% 
           str_trim() %>%
           str_remove_all(.,'^Bereit, weil Ihr es seid.') %>%
           str_remove_all(.,'^Bundestagswahlprogramm 2021') %>%
           str_remove_all(.,'^Das Zukunftsprogramm der SPD') 
           ) %>%
  mutate(party = str_remove_all(party, '^raw_data/') %>% str_remove(.,'\\.pdf'))


texts_collapsed <- texts_clean %>%
  group_by(party) %>%
  summarise(text = paste0(text, collapse = ' '))

write_csv(texts_collapsed, file = 'raw_data/texts.csv')

