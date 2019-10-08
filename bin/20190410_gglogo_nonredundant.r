#Install packages
pacman::p_load("readxl", "tidyverse", "gridExtra", "ggseqlogo", "cowplot")

#Set working directory
setwd("~/Documents/University_of_Minnesota/Wackett_Lab/github/thiolase_superfamily_alignment/")

# Read in the results
rawdat <- read_csv("output/channels_pulled_per_seq.csv") %>%
  dplyr::group_by(query) %>%
  dplyr::mutate(channel_a_seq = paste0(a_query, collapse = ""),
                channel_b_seq = paste0(b_query, collapse = ""))

# Pull the source organisms
orgs <- read_csv("data/20190410_thiolase_pdb_ids_v2.csv") %>%
  janitor::clean_names()
head(orgs)

dedup <- orgs %>%
  distinct(structure_title, .keep_all = T) %>%
  distinct(sequence, .keep_all = T) %>%
  dplyr::mutate(pdb_3code = substr(pdb_id, 1, 3)) %>%
  distinct(pdb_3code, .keep_all = T)
dim(dedup)

# Manual curation of dataset
pdbrs <- c("1HN9", "1M1M", "1U6E", "2AJ9", "2AHB", "2QNY", "4X9K")
remdat <- dedup[!dedup$pdb_id %in% pdbrs,] %>%
  dplyr::mutate(query = paste0(pdb_id, "_A"))
dim(remdat)
write_csv(remdat, "data/20190410_thiolase_deduplicated.csv")

findat <- rawdat %>%
  dplyr::filter(query %in% remdat$query)
dim(findat)
324/12 

phylodat <- findat %>%
  left_join(., remdat, by = "query")
# write_csv(phylodat, "output/channel_seqs_merged_with_phylo.csv") 

### Channel A
a_dat <- findat %>%
  dplyr::select(query, channel_a_seq) %>%
  distinct(query, .keep_all = T)

olea_chan_a <- a_dat$channel_a_seq[a_dat$query == "4KU5_A"]

pdf("output/olea_channel_a_logo.pdf", width = 10, height = 2)
p <- ggplot() + geom_logo(olea_chan_a, method = "p", col_scheme = 'chemistry') + theme_logo() + 
  theme(legend.position = 'none', axis.text.x = element_blank()) 
p
dev.off()

achar <- as.character(a_dat$channel_a_seq)
length(achar)
pdf("output/channel_a_logo.pdf", width = 10, height = 12)
p <- ggplot() + geom_logo(achar, method = "p", col_scheme = 'chemistry') + theme_logo() + 
  theme(legend.position = 'none', axis.text.x = element_blank()) 
p
dev.off()


### Channel B

b_dat <- findat %>%
  dplyr::select(query, channel_b_seq) %>%
  distinct(query, .keep_all = T)

olea_chan_b <- b_dat$channel_b_seq[b_dat$query == "4KU5_A"]

pdf("output/olea_channel_b_logo.pdf", width = 10, height = 2)
p <- ggplot() + geom_logo(olea_chan_b, method = "p", col_scheme = 'chemistry') + theme_logo() + 
  theme(legend.position = 'none', axis.text.x = element_blank()) 
p
dev.off()

bchar <- as.character(b_dat$channel_b_seq)
bchar
pdf("output/channel_b_logo.pdf", width = 10, height = 12)
p <- ggplot() + geom_logo(bchar, method = "p", col_scheme = 'chemistry') + theme_logo() + 
  theme(legend.position = 'none', axis.text.x = element_blank()) 
p
dev.off()
