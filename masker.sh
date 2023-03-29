#!/bin/bash

# Shamelessly copied from https://bioinformatics.stackexchange.com/questions/2373/is-it-wise-to-use-repeatmasker-on-prokaryotes

startdir=$(pwd)
genome=$1
base=$(basename $genome .fasta)
base=$(basename $base .fa)
maskpath="${startdir}/${base}_masked.fa"
bedpath="${startdir}/${base}_repeats.bed"
deltapath="${startdir}/${base}.delta"
tmpdir=$(mktemp -d)

# nucmer doesn't like working in remote fs, since it gets permissions wrong
#   copy fasta files to temporary dir, run nucmer on those, copy output back
tmp_genome="${tmpdir}/${genome}"
cp ${genome} ${tmp_genome}
cd ${tmpdir}

# align genome against itself
nucmer --maxmatch --nosimplify ${genome} ${genome}
cp out.delta ${deltapath}
cd ${startdir}

rm -R ${tmpdir}

# select repeats and convert the corrdinates to bed format
show-coords -r -T -H ${deltapath} \
    | awk '{if ($1 != $3 && $2 != $4) print $0}' \
    | awk '{print $8"\t"$1"\t"$2}' \
    > ${bedpath}

# mask those bases with bedtools
echo "bedtools maskfasta -fi ${genome} -bed ${bedpath} -fo ${maskpath}"
bedtools maskfasta -fi ${genome} -bed ${bedpath} -fo ${maskpath}
