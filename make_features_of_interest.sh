#!/usr/bin/bash

anno_file="B_subtilis_PY79_consensus_rRNA_with_ncRNA.gff"
awk '$3 == "tRNA"' $anno_file \
    > B_subtilis_PY79_CP006881.1_tRNA.gff
awk '$3 == "rRNA"' $anno_file \
    > B_subtilis_PY79_CP006881.1_rRNA.gff
awk '$3 == "CDS"' $anno_file \
    > B_subtilis_PY79_CP006881.1_CDS.gff
grep 5\' $anno_file \
    > B_subtilis_PY79_CP006881.1_5_UTR.gff
grep 3\'UTR $anno_file \
    > B_subtilis_PY79_CP006881.1_3_UTR.gff
awk '$3 == "indep"' $anno_file \
    > B_subtilis_PY79_CP006881.1_ncRNA.gff
echo -e "CP006881.1\t4033459" > B_subtilis_PY79_consensus_rRNA.genome
echo -e "B_subtilis_PY79_consensus_5S_rRNA\t116" >> B_subtilis_PY79_consensus_rRNA.genome
echo -e "B_subtilis_PY79_consensus_16S_rRNA\t1555" >> B_subtilis_PY79_consensus_rRNA.genome
echo -e "B_subtilis_PY79_consensus_23S_rRNA\t2928" >> B_subtilis_PY79_consensus_rRNA.genome

# get top 100 expressed CDSs
eval "$(conda shell.bash hook)"
conda activate rnap_chip2
Rscript merge_expression.R \
    --gff_file B_subtilis_PY79_CP006881.1_CDS.gff \
    --exp_file CDS_exp.tsv \
    --out_fname CDS_with_exp.gff
sort -n -k 10 CDS_with_exp.gff > sorted_CDS_with_exp.gff

conda activate ipod
# get top 20%
wcres=$(wc -l sorted_CDS_with_exp.gff)
echo $wcres
featnum=$(echo $wcres | cut -f1 -d" " -)
echo $featnum
let "num = ${featnum} / 5"
echo $num
head -n $num sorted_CDS_with_exp.gff | cut -f 1-9 > exp_sorted_top_20_CDS.gff
tail -n $num sorted_CDS_with_exp.gff | cut -f 1-9 > exp_sorted_bottom_20_CDS.gff

bedtools sort -i exp_sorted_top_20_CDS.gff > B_subtilis_PY79_CP006881.1_top_20_CDS.gff
bedtools sort -i exp_sorted_bottom_20_CDS.gff > B_subtilis_PY79_CP006881.1_bottom_20_CDS.gff

