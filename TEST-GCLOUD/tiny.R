args <- commandArgs(TRUE)
fname <- args[1]
df <- read.delim(fname, header = FALSE, sep = '\n')
mdf <- max(df[,1])
cat(mdf, '\n')
