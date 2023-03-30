#!/usr/bin/env Rscript
library(optparse)
library(tidyverse)

options(stringsAsFactors=FALSE)

option_list = list(
    make_option(
        c("--gff_file"), type="character", default=NULL, 
        help="gff file with annotations to place expression values onto",
    ),
    make_option(
        c("--out_fname"), type="character", default=NULL, 
        help="file with output",
    ),
    make_option(
        c("--exp_file"), type="character", default=NULL, 
        help="tsv file with expression values",
    )   
)
 
print("Reading command line options")
opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

gff = read.delim(
    file=opt$gff_file,
    header=FALSE,
    col.names=c("seqnames","source","feature","start","end","score","strand","display","info")
 )

CDS = gff %>% filter(feature=="CDS")
locus_tags = locus_tags = str_extract(CDS$info, paste0("(?<=locus_tag=)","U712_\\d{5}"))
CDS$locus_tag = locus_tags

exp = read.delim(
    file=opt$exp_file,
    header=TRUE
) %>%
    dplyr::select(c(locus_tag,PY79_rpkm))

CDS = CDS %>%
    left_join(exp)

write.table(CDS, file=opt$out_fname, row.names=FALSE, col.names=FALSE, sep="\t", quote=FALSE)
