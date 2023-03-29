
awk '$3 ~ "rRNA"' B_subtilis_PY79_CP006881.1.gff \
    | grep "product=16S ribosomal RNA" - \
    > B_subtilis_PY79_16S.gff
awk '$3 ~ "rRNA"' B_subtilis_PY79_CP006881.1.gff \
    | grep "product=23S ribosomal RNA" - \
    > B_subtilis_PY79_23S.gff
awk '$3 ~ "rRNA"' B_subtilis_PY79_CP006881.1.gff | \
    grep "product=5S ribosomal RNA" - > \
    B_subtilis_PY79_5S.gff

bedtools getfasta \
    -fi bsub_py79.fasta \
    -bed B_subtilis_PY79_16S.gff \
    > B_subtilis_PY79_16S_seqs.fa
bedtools getfasta \
    -fi bsub_py79.fasta \
    -bed B_subtilis_PY79_23S.gff \
    > B_subtilis_PY79_23S_seqs.fa
bedtools getfasta \
    -fi bsub_py79.fasta \
    -bed B_subtilis_PY79_5S.gff \
    > B_subtilis_PY79_5S_seqs.fa

