# Creating custom reference genome and annotations

The following steps can be taken to build the custom annotations and reference genome used
in our analysis of RNA:DNA hybrid enrichments in Bacillus subtilis.

## Annotations

Downloaded genome features for CP006881.1 from NCBI

### Getting ncRNA other than rRNA and tRNA from Nicolas et al

Made `B_subtilis_168_RNA.tsv` by starting with Table S5
from Nicolas et al., and filtering for features for which either the "classif" column was not "-"
or the "Locus\_tag" column contained "BSU\_misc"

```bash
./get_ncrna.sh
```

### Getting consensus 16S, 23S, 5S rRNA

```bash
./get_rRNA_seqs.sh
```

Then I uploaded the files to EMBOSS Cons to get consensus
sequences in files `B_subtilis_PY79_consensus_16S_rRNA.fa`,
`B_subtilis_PY79_consensus_23S_rRNA.fa`, and
`B_subtilis_PY79_consensus_5S_rRNA.fa`.

### Creating final reference genome

Made masked reference sequence

The following creates `PY79_CC_P2918_masked.fa`:

```bash
./masker.sh PY79_CC_P2918.fasta
```

Supplementing masked reference with B sub consensus
rRNA sequences

```bash
cat PY79_CC_P2918_masked.fa B_subtilis_PY79_consensus_5S_rRNA.fa B_subtilis_PY79_consensus_23S_rRNA.fa B_subtilis_PY79_consensus_16S_rRNA.fa > PY79_CC_P2918_masked_consensus_rRNA.fa

bowtie2-build PY79_CC_P2918_masked_consensus_rRNA.fa PY79_CC_P2918_masked

# produces file "B_subtilis_PY79_consensus_rRNA.gff"
./make_B_sub_consensus_rRNA_gff.sh
```

```
cat B_subtilis_PY79_ncRNA_with_class.gff B_subtilis_PY79_consensus_rRNA.gff > tmp.gff
bedtools sort -i tmp.gff > B_subtilis_PY79_consensus_rRNA_with_ncRNA.gff
rm tmp.gff
```
