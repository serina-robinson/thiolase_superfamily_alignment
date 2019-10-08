### Functions
extract_channel_a <- function(aln) {
  # channel_a <- sort(c(253, 349, 345, 351, 353, 343, 261, 284, 258, 295, 292, 291))
  channel_a <- c(253, 258, 261, 284, 291, 292, 295, 343, 345, 349, 351, 353)
  channel_a_res <- c("L", "I", "A", "I", "H", "T", "F", "L", "I", "L", "C", "M")
  his_tag <- "MGSSHHHHHHSSGLVPRGS"
  nhis <- nchar(his_tag)
  
  channel_a_adj <- channel_a - nhis
  
  template_aln <- as.character(aln$ali[1,])
  query_aln <- as.character(aln$ali[2,])
  template_aln
  query_aln
  
  temp_l <- list()
  query_l <- list()
  for(i in 1:length(channel_a_adj)) {
    tally <- 0 
    for(j in 1:channel_a_adj[i]) {
      if(template_aln[j] == "-") {
        tally <- tally + 1
      }
    }
    temp_l[[i]] <- template_aln[channel_a_adj[i] + tally]
    query_l[[i]] <- query_aln[channel_a_adj[i] + tally]
  }
  
  return(list(temp_l = temp_l, query_l = query_l))
}

extract_channel_b <- function(aln) {
  channel_b <- sort(c(176, 173, 172, 242, 243, 112, 111, 171, 117, 316, 203, 246))
  channel_b_res <- c("V", "S", "E", "E", "T", "A", "V", "L", "N", "L", "M", "I")
  his_tag <- "MGSSHHHHHHSSGLVPRGS"
  nhis <- nchar(his_tag)
  
  channel_b_adj <- channel_b - nhis
  
  template_aln <- as.character(aln$ali[1,])
  query_aln <- as.character(aln$ali[2,])
  template_aln
  query_aln
  
  temp_l <- list()
  query_l <- list()
  for(i in 1:length(channel_b_adj)) {
    tally <- 0 
    for(j in 1:channel_b_adj[i]) {
      if(template_aln[j] == "-") {
        tally <- tally + 1
      }
    }
    temp_l[[i]] <- template_aln[channel_b_adj[i] + tally]
    query_l[[i]] <- query_aln[channel_b_adj[i] + tally]
  }
  
  return(list(temp_l = temp_l, query_l = query_l))
}


extract_channels_super <- function(template, query) {
  # Function that superimposes thiolase structs with OleA (4KTI)
  # Inputs: template and sequence pdb objects
  # Extracts channel A and channel B residues
  # Returns as a named list with channel A res and channel B res
  
  superaln <- pdbaln(c(template, query), fit = TRUE)
  
  a_query <- extract_channel_a(superaln)
  b_query <- extract_channel_b(superaln)
  

  querynam <- gsub("data/pdb_fils/split_chain//", "", query)
  querynam2 <- gsub("\\.pdb", "", querynam)
  return(list(query = querynam2, 
              a_temp = unlist(a_query$temp_l),
              a_query = unlist(a_query$query_l), 
              b_temp = unlist(b_query$temp_l),
              b_query = unlist(b_query$query_l)))
}


# extract_channels_struct <- function(template, query) {
# Function that superimposes thiolase structs with OleA (4KTI)
# Inputs: template and sequence pdb objects
# Extracts channel A and channel B residues
# Returns as a named list with channel A res and channel B res
#   structaln <- struct.aln(template, query, fixed.inds = NULL, write.pdbs = TRUE,
#                        outpath = "data/test_alignment.txt") # TODO, set these
#   return(tmp_aln)
# }
