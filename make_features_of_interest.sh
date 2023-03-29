#!/usr/bin/bash
anno_file="B_subtilis_PY79_consensus_rRNA_with_ncRNA.gff"
awk '$3 == "tRNA"' $anno_file \
    > B_subtilis_PY79_CP006881.1_tRNA.gff
awk '$3 == "rRNA"' $anno_file \
    > B_subtilis_PY79_CP006881.1_rRNA.gff
awk '$3 == "CDS"' $anno_file \
    > B_subtilis_PY79_CP006881.1_CDS.gff
echo -e "CP006881.1\t4033459" > B_subtilis_PY79_consensus_rRNA.genome
echo -e "B_subtilis_PY79_consensus_5S_rRNA\t116" >> B_subtilis_PY79_consensus_rRNA.genome
echo -e "B_subtilis_PY79_consensus_16S_rRNA\t1555" >> B_subtilis_PY79_consensus_rRNA.genome
echo -e "B_subtilis_PY79_consensus_23S_rRNA\t2928" >> B_subtilis_PY79_consensus_rRNA.genome
bedtools flank -l 50 -r 0 -s -i $anno_file \
    -g B_subtilis_PY79_consensus_rRNA.genome \
    | bedtools sort -i - \
    > B_subtilis_PY79_CP006881.1_5_UTR.gff
bedtools flank -l 0 -r 50 -s -i $anno_file \
    -g B_subtilis_PY79_consensus_rRNA.genome \
    | bedtools sort -i - \
    > B_subtilis_PY79_CP006881.1_3_UTR.gff

# get top 100 expressed CDSs
eval "$(conda shell.bash hook)"
conda activate rnap_chip2
datadir=/corexfs/schroedj/hbd_enrichment
Rscript $datadir/merge_expression.R \
    --gff_file /corexfs/schroedj/Anno/B_subtilis_PY79_CP006881.1_CDS.gff \
    --exp_file /corexfs/schroedj/hbd_enrichment/CDS_exp.tsv \
    --out_fname CDS_with_exp.gff
sort -n -k 10 CDS_with_exp.gff > sorted_CDS_with_exp.gff
head -n 100 sorted_CDS_with_exp.gff | cut -f 1-9 > exp_sorted_top_100_CDS.gff

conda deactivate
conda activate ipod
bedtools sort -i exp_sorted_top_100_CDS.gff > top_100_CDS.gff
mv top_100_CDS.gff /nfs/corenfs/biochem-freddolino-lab/schroedj/Anno/B_subtilis_PY79_CP006881.1_top_100_CDS.gff

cd /nfs/corenfs/biochem-freddolino-lab/schroedj/Anno
bedtools flank -l 50 -r 0 -s -i B_subtilis_PY79_CP006881.1_top_100_CDS.gff \
    -g B_subtilis_PY79_CP006881.1.genome \
    | bedtools sort -i - \
    > B_subtilis_PY79_CP006881.1_top_100_5_UTR.gff
bedtools flank -l 0 -r 50 -s -i B_subtilis_PY79_CP006881.1_top_100_CDS.gff \
    -g B_subtilis_PY79_CP006881.1.genome \
    | bedtools sort -i - \
    > B_subtilis_PY79_CP006881.1_top_100_3_UTR.gff

