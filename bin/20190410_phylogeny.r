#Install packages
pacman::p_load("readxl", "tidyverse", "gridExtra", "ggseqlogo", "cowplot")

#Set working directory
setwd("~/Documents/University_of_Minnesota/Wackett_Lab/github/thiolase_superfamily_alignment/")

# Read in the phylogeny
phylo2 <- read_csv("output/channel_seqs_merged_with_phylo.csv")
