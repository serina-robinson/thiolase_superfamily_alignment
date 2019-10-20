# Install packages
pacman::p_load("webchem", "readxl", "tidyverse", "ChemmineR", "data.table", "plot3D", "plot3Drgl", "ggrepel")

# Set working directory
setwd("~/Documents/University_of_Minnesota/Wackett_Lab/github/thiolase_superfamily_alignment/")

# Read in the list of compounds
ll <- list.files("data/sigma_carboxylic_acid_scrape/", pattern = "C")
data_path <- "data/sigma_carboxylic_acid_scrape/"
rawdat <- tibble(filename = ll) %>%
  # purrr::map(read_excel) %>%   
  mutate(file_contents = map(filename,          # read files into
                             ~ read_excel(file.path(data_path, .))) # a new data column
  ) %>%
  unnest(.)  # read in all the files individually

dim(rawdat)
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
  dplyr::distinct(cmpnd, .keep_all = TRUE) %>%
  dplyr::mutate(carbon_num = word(filename, 1, sep = "\\.xlsx"))
head(dat)

c_length <- dat %>%
  select(carbon_num, cmpnd)
head(c_length)
# dat$cmpnd[!grepl("acid", dat$cmpnd)]
# write_csv(data.frame(cbind(dat$description, dat$cmpnd)), "output/test_cmpnd_description.csv")


length(dat$cmpnd)
test_pull <- dat$cmpnd
table(duplicated(dat$cmpnd))

# ll_cids <- get_cid(test_pull)
nams <- names(all_cids)
cids <- unlist(all_cids)

cid_df <- data.frame(as.matrix(all_cids)) %>%
  rename(cids = as.matrix.all_cids.) %>%
  unlist() %>%
  na.omit() %>%
  as.data.frame()
colnames(cid_df)

cid_df$cmpnd <- rownames(cid_df)
head(cid_df)
colnames(cid_df)[1] <- "cid"
final_df <- cid_df %>%
  mutate(cid = as.numeric(cid))

key <- final_df
head(key)
key$cmpnd <- gsub("cids\\.", "", key$cmpnd)

#write_csv(key, "output/CID_cmpnd_name_key.csv")

# write_delim(data.frame(final_df$cid), "data/CA_cids_output.txt", delim = "\t", col_names = F)
final_df <- read_delim("data/CA_cids_output.txt", delim = "\t", col_names = F)

sdfset <- read.SDFset("data/sigma_CAs.sdf")
cid_pulled <- as.numeric(unlist(lapply(1:length(sdfset), function(x) { header(sdfset[[x]])[1] })))
length(unique(cid_pulled))


apset <- sdf2ap(sdfset)

key <- read_csv("output/CID_cmpnd_name_key.csv")
key_jnd <- key %>%
  inner_join(., c_length, by = "cmpnd")
head(key_jnd)

newnams <- key$cmpnd[!duplicated(key$cid)]
newnams

apset@ID <- newnams


# apset@ID <- gsub("1$", "", apset@ID)

# keys <- read_delim("data/all_cids_output.txt", delim = "\t")

# apdups <- cmp.duplicated(apset, type=1)
# # sdfset2 <- sdfset[which(!apdups)]
# # apset2 <- apset[which(!apdups)]
# # fpset2 <- desc2fp(apset2)

length(apset)
# clusters <- cmp.cluster(db=apset,  cutoff=0.7, save.distances = "data/distmat.rda")
clusters <- cmp.cluster(db=apset,  cutoff = 0.4, save.distances = "data/distmat.rda")
head(clusters)
# write_csv(clusters, "output/sigma_CA_tanimoto_clusters.csv")
cluster.sizestat(clusters) # 56, 25 ,2


clusviz <- cluster.visualize(apset, clusters, size.cutoff = 1, quiet = TRUE)
x <- clusviz[,1]
y <- clusviz[,2]
trdat <- data.frame(cbind(x,y))
names(x)
rownames(trdat) <- names(x)
head(trdat)
trdat$cmpnd <- rownames(trdat)

head(trdat)
dim(trdat)

Larrys_comps <- read_excel("data/sigma_carboxylic_acid_scrape/Larry_preferred_substrates.xlsx", col_names = F)

subgrp <- trdat %>%
  left_join(., key_jnd, by = "cmpnd") %>%
  dplyr::mutate(Larry_choices = ifelse(cmpnd %in% Larrys_comps$...1, cmpnd, NA)) %>%
  dplyr::distinct()
head(subgrp)

#table(grepl(paste0(Larrys_comps$...1, collapse = "|"), subgrp$cmpnd))
# tofind <- subgrp$cmpnd[grepl(paste0(collapse = "|", Larrys_comps$...1[!Larrys_comps$...1 %in% subgrp$cmpnd]), subgrp$cmpnd)]


head(subgrp)
numseqs <- nrow(subgrp)
pdf(paste0("output/", numseqs,"_PCoA_labeled_CA_Sigma.pdf"), width = 10, height = 10)
par(mar=c(0.01, 0.01, 0.01, 0.01))
ggplot(data = subgrp, aes(x=x, y=y, label = Larry_choices)) + 
  # geom_text(label = trdat$nms) +
  # geom_text(x = cdat$x, y = cdat$y, label = cdat$labl, check_overlap = T) +
  geom_point() +
  geom_point(aes(fill = as.factor(subgrp$carbon_num)), shape = 21, size = 4) +
  scale_shape(solid = TRUE) +
  geom_label_repel() +
  # labs(x=xlab,y=ylab) +
  theme_bw() + 
  theme(axis.text = element_text(size = 14),
        legend.key = element_rect(fill = "white"),
        legend.background = element_rect(fill = "white"),
        legend.position = "top",
        legend.box = "horizontal",
        legend.text = element_text(size = 20),
        legend.title = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title=element_text(size=14, face="bold", hjust=0))
dev.off()

