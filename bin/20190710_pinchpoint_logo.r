# Install packages
pacman::p_load("readxl", "tidyverse", "gridExtra", "ggseqlogo", 
               "cowplot", "Biostrings", "DECIPHER", "ggtree")

# Set working directory
setwd("~/Documents/University_of_Minnesota/Wackett_Lab/github/thiolase_superfamily_alignment/")

# Read in seq logo
logos <- read_csv("output/pinch_point_1_with_structs.csv")

pdf("output/pinch_point_logo.pdf", width = 4, height = 6)
p <- ggplot() + geom_logo(logos$pinch_pt1, method = "p", col_scheme = 'chemistry') + theme_logo() + 
  theme(legend.position = 'none', axis.text.x = element_blank()) 
p
dev.off()
