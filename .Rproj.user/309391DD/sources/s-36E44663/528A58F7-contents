#### PAUL BOCHTLER 
#### 09.10.2021

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


corpus <- corpus(texts_clean)

tokens <- tokens(corpus, remove_punct = T) %>%
  tokens_remove(stopwords::stopwords('de'))

dfm <- dfm(tokens)

freq <- textstat_frequency(dfm,groups = 'party') %>% 
  group_by(group) %>% 
  mutate(total = sum(frequency)) %>%
  slice_max(order_by = frequency, n = 20)


texts_collapsed <- texts_clean %>%
  group_by(party) %>%
  summarise(text = paste0(text, collapse = ' '))

write_csv(texts_collapsed, file = 'raw_data/texts.csv')

corpus <- corpus(texts_collapsed)

docnames(corpus) <- texts_collapsed$party

tokens <- tokens(corpus, remove_punct = T) %>%
  tokens_remove(stopwords::stopwords('de'))

dfm <- dfm(tokens)

textstat_summary(dfm)
quanteda.textstats::textstat_dist(dfm,dfm['koalition',], method = 'manhattan')
textstat_simil(dfm, method = 'jaccard',margin = "documents")




model <- word2vec(texts_collapsed$text)

emb <- doc2vec(model, texts_collapsed$text[texts_collapsed$party == 'spd'], type = "embedding")

newdoc <- doc2vec(model, texts_collapsed$text[texts_collapsed$party == 'koalition'])

word2vec_similarity(emb, newdoc)


fdp_matrix <- readr::read_csv('../results/matrix_fdp.csv')
spd_matrix <- readr::read_csv('../results/matrix_spd.csv')
gruene_matrix <- readr::read_csv('../results/matrix_gruene.csv')

fdp_data <- readr::read_csv('../results/data_fdp.csv')
coal_data <- readr::read_csv('../results/data_coal.csv')
gruene_data <- readr::read_csv('../results/data_gruene.csv')
spd_data <- readr::read_csv('../results/data_spd.csv')