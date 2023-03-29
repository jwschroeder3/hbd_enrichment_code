
makeblastdb \
    -in bsub_py79.fasta \
    -dbtype nucl \
    -title B_subtilis_PY79_CP006881.1 \
    -out B_subtilis_PY79_CP006881.1

awk -F"\t" 'BEGIN {OFS="\t"} NR > 1 {if ($5 == 1) {strand="+"} if ($5 == -1) {strand="-"}; print "AL009126.3",$3-1,$4,$2,$1,strand}' B_subtilis_168_RNA.tsv > B_subtilis_168_RNA.bed
bedtools getfasta \
    -fi B_subtilis_168_AL009126.3.fa \
    -fo B_subtilis_168_ncRNA.fa \
    -bed B_subtilis_168_RNA.bed \
    -name \
    -s

# map 168 ncRNAs to PY79 (1634 in 168 file, 1558 hits in results of this blastn)
blastn -db B_subtilis_PY79_CP006881.1 \
    -query B_subtilis_168_ncRNA.fa \
    -out B_subtilis_168_ncRNA_PY_blast.tsv \
    -max_hsps 1 \
    -evalue 0.01 \
    -outfmt 6

# create bed file
awk -F"\t" 'BEGIN {OFS="\t"} {if ($9 < $10) {strand="+"; start=$9; end=$10} if ($10 < $9) {strand="-"; start=$10; end=$9} print $2,start,end,$1,$11,strand}' B_subtilis_168_ncRNA_PY_blast.tsv > B_subtilis_PY79_ncRNA.bed

# join to get Nicolas et al.'s classifications
sort -k 4 B_subtilis_PY79_ncRNA.bed > B_subtilis_PY79_ncRNA_keysort.bed
tail -n +2 B_subtilis_168_RNA_class_lut.tsv | sort -k 3 - > B_subtilis_168_RNA_class_lut_keysort.tsv

join -1 4 -2 3 \
    B_subtilis_PY79_ncRNA_keysort.bed \
    B_subtilis_168_RNA_class_lut_keysort.tsv \
    | awk 'BEGIN {OFS="\t"} {print $2,$3,$4,$8,$5,$6,$1,$7,$9}' \
    | sort -k 3 -n - \
    > B_subtilis_PY79_ncRNA_with_class.bed

awk -F"\t" 'BEGIN {OFS="\t"} { print $1,"Jeremy_via_Nicolas_et_al",$9,$2+1,$3,".",$6,0,"ID="$4";Name="$8";locus_tag="$4 }' B_subtilis_PY79_ncRNA_with_class.bed > B_subtilis_PY79_ncRNA_with_class.gff

