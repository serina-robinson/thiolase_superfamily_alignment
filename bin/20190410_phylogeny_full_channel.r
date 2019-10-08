#Install packages
pacman::p_load("readxl", "tidyverse", "gridExtra", "ggseqlogo", 
               "cowplot", "Biostrings", "DECIPHER", "ggtree")

#Set working directory
setwd("~/Documents/University_of_Minnesota/Wackett_Lab/github/thiolase_superfamily_alignment/")

# Read in the structure names 
struct_nams <- read_csv("output/struct_nams.csv")
head(struct_nams)

# Read in the raw data
rawdat$channel_a_seq[rawdat$pdb_id == "4KU5"]
rawdat <- read_csv("output/channel_seqs_merged_with_phylo.csv") %>%
  dplyr::mutate(pinch_pt1 = paste0(substr(channel_a_seq, 2, 4), substr(channel_a_seq, 6, 6), substr(channel_a_seq, 9, 9)))


structdat <- rawdat %>%
  inner_join(., struct_nams, by  = c("structure_title" = "title")) %>%
  dplyr::filter(!grepl("4X9K", pdb_id))
colnames(structdat)

findat <- structdat %>%
  dplyr::mutate(newnams = paste0(substr(query, 1, 4), "_", gsub(" ", "_", source), "_", gene_name))


uniq_dat <- findat %>%
  dplyr::distinct(query, .keep_all = TRUE)
length(uniq_dat$query)

# First read in the full sequences
all_seqs <- readAAStringSet("data/thiolase_fasta.faa")
a_seqs <- all_seqs[grep("\\:A", names(all_seqs))]
# Remove Vibrio
a_seqs <- a_seqs[-grep("4X9K", names(a_seqs))]
length(a_seqs)
# names(all_seqs) <- substr(names(all_seqs), 1, 4)

# Trim the sequences down to those of interest
trsqs <- a_seqs[grep(paste0(unique(rawdat$pdb_id), collapse = "|"), names(a_seqs))]
head(trsqs)
unique(findat$newnams)

names(trsqs) <- unique(findat$newnams)

# writeXStringSet(trsqs, "output/26_thiolase_unaligned.fasta")

# Align sequences
aa_al <- AlignSeqs(trsqs)
aa_adj <- AdjustAlignment(aa_al)
# BrowseSeqs(aa_al)
# writeXStringSet(aa_adj, "output/26_thiolase_aligned.fasta")

# Read in the Newick file of the sequences
# nwk <- treeio::read.tree("data/26_thiolase_aligned.nwk") # no bootstrapped
nwk <- treeio::read.tree("data/26_thiolase_aligned_500bootstraps.nwk")
# nwk <- treeio::read.tree("output/megax_26thiolase_bootstrapped_500_JTT.nwk")
head(nwk)

# Annotation data frame
gt <- ggtree(nwk)
gt$data$label
dtf <- data.frame(uniq_dat$newnams, uniq_dat$pinch_pt1, rep(NA, length(uniq_dat$pinch_pt1)))

# Calculate unique occurences
writeLines(unique(as.character(dtf$pinch_pt1)[-grep("-", as.character(dtf$pinch_pt1))]), sep = ", ")
length(table(as.character(dtf$pinch_pt1)[-grep("-", as.character(dtf$pinch_pt1))]))
write_csv(dtf, "output/pinch_point_1_with_structs.csv")


colnames(dtf) <- c("label", "pinch_pt1", "bootstrap")
gtd <- gt %<+% dtf
gtd$data$bootstrap
gtd$data$bootstrap[!gtd$data$isTip] <- floor(as.numeric(gtd$data$label[!gtd$data$isTip])* 100)
gtd$data$bootstrap

pdf("output/26_thiolase_ggtree_pinch_pt1_mega7_500boot_5res.pdf")
gtd +
  geom_tiplab() +
  geom_text(aes(label = as.character(pinch_pt1), x = 4.5)) +
  geom_label2(aes(label = bootstrap, subset = !isTip), size = 2) +
  xlim(NA, 5)
dev.off()
