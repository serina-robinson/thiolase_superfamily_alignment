# Install packages
pacman::p_load("webchem", "readxl", "tidyverse", "ChemmineR", "data.table", "plot3D", "plot3Drgl", "ggrepel")

# Set working directory
setwd("~/Documents/University_of_Minnesota/Wackett_Lab/github/thiolase_superfamily_alignment/")

# Read in the list of compounds
ll <- list.files("data/sigma_carboxylic_acid_scrape/", pattern = "C", full.names = T)
rawdat <- ll %>%
  map(read_excel) %>%    # read in all the files individually
  reduce(rbind)
head(rawdat)

# Read in one plot
dat <- rawdat %>%
  janitor::clean_names() %>%
  dplyr::filter(!is.na(description)) %>%
  dplyr::mutate(cmpnd = case_when(grepl("acid", description) ~ paste0(word(description, sep = "acid", 1), "acid"),
                                  TRUE ~ trimws(paste0(word(description, sep = "[[:digit:]][[:digit:]]%", 1))))) %>%
  dplyr::mutate(cmpnd = gsub(" AldrichCPR", "", cmpnd)) %>%
  dplyr::mutate(cmpnd = gsub("\\(GC\\)", "", cmpnd)) %>%
  dplyr::mutate(cmpnd = gsub("\\(HPLC\\)", "", cmpnd)) %>%
  dplyr::mutate(cmpnd = gsub("≥[[:digit:]][[:digit:]]\\.[[:digit:]]%", "", cmpnd)) %>%
  dplyr::mutate(cmpnd = gsub("\\(~", "", cmpnd)) %>%
  dplyr::mutate(cmpnd = trimws(cmpnd)) %>%
  dplyr::distinct(cmpnd, .keep_all = TRUE)
dat$cmpnd[!grepl("acid", dat$cmpnd)]
write_csv(data.frame(cbind(dat$description, dat$cmpnd)), "output/test_cmpnd_description.csv")
# dat$cmpnd[grep("isovaleric", dat$cmpnd)]
length(dat$cmpnd)
test_pull <- dat$cmpnd
table(duplicated(dat$cmpnd))

#ll_cids <- get_cid(test_pull)
all_cids

cid_df <- data.frame(as.matrix(all_cids)) %>%
  rename(cids = as.matrix.all_cids.) %>%
  unlist() %>%
  na.omit() %>%
  as.data.frame()
colnames(cid_df)

cid_df$cmpnd <- rownames(cid_df)
colnames(cid_df)[1] <- "cid"
final_df <- cid_df %>%
  mutate(cid = as.numeric(cid))

write_delim(data.frame(final_df$cid), "data/CA_cids_output.txt", delim = "\t", col_names = F)
final_df <- read_delim("data/CA_cids_output.txt", delim = "\t", col_names = F)
head(final_df)
