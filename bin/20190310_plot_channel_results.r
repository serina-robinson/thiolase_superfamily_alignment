#Install packages
pacman::p_load("readxl", "tidyverse", "gridExtra", "ggseqlogo", "cowplot")

#Set working directory
setwd("~/Documents/University_of_Minnesota/Wackett_Lab/github/thiolase_superfamily_alignment/")

# Read in the results
rawdat <- read_csv("output/channels_pulled_per_seq.csv") %>%
  dplyr::group_by(query) %>%
  dplyr::mutate(channel_a_seq = paste0(a_query, collapse = ""),
                channel_b_seq = paste0(b_query, collapse = ""))

### Channel A
a_dat <- rawdat %>%
  dplyr::select(query, channel_a_seq) %>%
  distinct(query, .keep_all = T)

olea_chan_a <- a_dat$channel_a_seq[a_dat$query == "4KTI_A"]

pdf("output/olea_channel_a_logo.pdf", width = 10, height = 2)
p <- ggplot() + geom_logo(olea_chan_a, method = "p", col_scheme = 'chemistry') + theme_logo() + 
  theme(legend.position = 'none', axis.text.x = element_blank()) 
p
dev.off()

achar <- as.character(a_dat$channel_a_seq)
pdf("output/channel_a_logo.pdf", width = 10, height = 12)
p <- ggplot() + geom_logo(achar, method = "p", col_scheme = 'chemistry') + theme_logo() + 
  theme(legend.position = 'none', axis.text.x = element_blank()) 
p
dev.off()


### Channel B

b_dat <- rawdat %>%
  dplyr::select(query, channel_b_seq) %>%
  distinct(query, .keep_all = T)

olea_chan_b <- b_dat$channel_b_seq[b_dat$query == "4KTI_A"]

pdf("output/olea_channel_b_logo.pdf", width = 10, height = 2)
p <- ggplot() + geom_logo(olea_chan_b, method = "p", col_scheme = 'chemistry') + theme_logo() + 
  theme(legend.position = 'none', axis.text.x = element_blank()) 
p
dev.off()

bchar <- as.character(b_dat$channel_b_seq)
pdf("output/channel_b_logo.pdf", width = 10, height = 12)
p <- ggplot() + geom_logo(bchar, method = "p", col_scheme = 'chemistry') + theme_logo() + 
  theme(legend.position = 'none', axis.text.x = element_blank()) 
p
dev.off()
