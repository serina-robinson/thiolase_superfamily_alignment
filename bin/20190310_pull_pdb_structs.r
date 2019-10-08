#Install packages
pacman::p_load("bio3d", "Biostrings", "readxl", "tidyverse", "plyr")

#Set working directory
setwd("~/Documents/University_of_Minnesota/Wackett_Lab/github/thiolase_superfamily_alignment/")

# Parse PFAM structrue file PF008545
pf <- read_excel("data/20190310_PF008545_struct_scrape.xlsx") %>%
  janitor::clean_names() %>%
  dplyr::filter(!grepl("Jmol", pdb_id)) %>%
  dplyr::filter(nchar(pdb_id) == 4 || nchar(uni_prot_entry) == 4) %>%
  dplyr::mutate(final_pdb = case_when(nchar(uni_prot_entry) == 4 ~ uni_prot_entry,
                                      nchar(pdb_id) == 4 ~ pdb_id))
pdba <- pf$final_pdb
pdba # 87 structures

# pdbfils <- get.pdb(pdba, path = "data/pdb_fils/", URLonly = FALSE, overwrite = FALSE, split = TRUE)
pdbfils_raw <- list.files("data/pdb_fils/split_chain/", full.names = T)[grep("_A", list.files("data/pdb_fils/split_chain/"))]
pdbnams_raw <- gsub("_A\\.pdb", "", list.files("data/pdb_fils/split_chain/")[grep("_A", list.files("data/pdb_fils/split_chain/"))])

olea_template <- "4KTI" #"4KTM"
length(oleas)
oleas <- c("3S1Z", "3ROW", "5VXD", "5VXF", "5VXH", "6B2R", "6B2S", "6B2T", "6B2U", "3S20", "3S21", "5VXE", "5VXG", "5VXI", "3S23", "4KU3", "4KU5", "4KU2")

pdbfils <- pdbfils_raw[!pdbnams_raw %in% oleas]
pdbnams <- pdbnams_raw[!pdbnams_raw %in% oleas]
pdbfils # 68 non-OleA structures

# ll <- list()
# ll <- lapply(pdbfils, read.pdb)
# head(ll)
# names(ll) <- pdbnams
# names(ll)
# 
# # Remove other OleA sequences?
# 
# # Align and superimpose two structures
# # al <- pdbaln(c(ll[names(ll) %in% c('1EBL', '1HN9')]), fit = TRUE)
# 
# # Extract sequences
# seqs <- lapply(1:length(ll), function(x) { ll[[x]]$atom$resid[ atom.select(ll[[x]],"calpha",chain="A")$atom] })
# seqAA <- lapply(seqs, aa321)
# 
# # Convert to AA String Set
# seq2 <- lapply(seqAA, function(x) { paste(x,collapse="") })
# seqstring <- lapply(seq2, AAString)
# seqset <- AAStringSet(seqstring)
# head(seqset)
# names(seqset) <- pdbnams
# head(pdbnams)


source("src/channel_alignment_scripts.r")
# Check by aligning OleA with itself
# aln <- extract_channels_super(ll[['4KTI']], ll[['4KTM']])

aln <- extract_channels_super(pdbfils[47], pdbfils[48]) # Template, query
aln

finres <- lapply(1:length(pdbfils), function(x) {
  extract_channels_super(pdbfils[47], pdbfils[x])
})
head(finres)

length(finres[[1]]$a_temp)
length(finres[[1]]$b_temp)
finres[[1]]$b_temp
# Convert to a data frame
df <- ldply(finres, data.frame)

# write_csv(df, "output/channels_pulled_per_seq.csv")
# a_queries <- lapply(1:length(finres), function(x) split(finres[[x]], finres[[x]]$a_query))


# Channel A
# chan_a_query_res <- unlist(extract_channel_a(aln))
# channel_a_res <- c("L", "I", "A", "I", "H", "T", "F", "L", "I", "L", "C", "M")
# cbind(channel_a_res, chan_a_query_res)
# 
# # Channel B
# channel_b_res <- c("V", "S", "E", "E", "T", "A", "V", "L", "N", "L", "M", "I")
# chan_b_query_res <- unlist(extract_channel_b(aln))
# cbind(channel_b_res, chan_b_query_res)



##### Write keys
channel_a <- c(253, 258, 261, 284, 291, 292, 295, 343, 345, 349, 351, 353)
channel_a_res <- c("L", "I", "A", "I", "H", "T", "F", "L", "I", "L", "C", "M")
write_csv(data.frame(paste0(channel_a_res, channel_a)), "data/channel_a_key.csv")
writeLines(paste0(channel_a_res, channel_a), sep = ", ")

channel_b <- sort(c(176, 173, 172, 242, 243, 112, 111, 171, 117, 316, 203, 246))
channel_b_res <- c("V", "S", "E", "E", "T", "A", "V", "L", "N", "L", "M", "I")
write_csv(data.frame(paste0(channel_b_res, channel_b_res)), "data/channel_b_key.csv")
writeLines(paste0(channel_b_res, channel_b), sep = ", ")
