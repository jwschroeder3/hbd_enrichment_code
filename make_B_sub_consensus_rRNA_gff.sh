#! /usr/bin/bash

# get the CDSs we'd filter out by simply using rRNA as filter
grep rRNA B_subtilis_PY79_CP006881.1.gff | grep CDS \
    > B_subtilis_PY79_CDS_with_rRNA_in_line.gff

# get all lines WITHOUT rRNA in them
grep -v rRNA B_subtilis_PY79_CP006881.1.gff > B_subtilis_PY79_no_lines_with_rRNA.gff

# place CDSs removed above back into gff file and sort it
cat B_subtilis_PY79_no_lines_with_rRNA.gff B_subtilis_PY79_CDS_with_rRNA_in_line.gff \
    > B_subtilis_PY79_no_chromosomal_rRNA.gff
bedtools sort -i B_subtilis_PY79_no_chromosomal_rRNA.gff \
    > B_subtilis_PY79_no_chromosomal_rRNA_sorted.gff

# insert consensus 5S, 16S, 23S
cp B_subtilis_PY79_no_chromosomal_rRNA_sorted.gff B_subtilis_PY79_consensus_rRNA.gff

# four lines, region, gene, rRNA, exon, for each rRNA

# 5S region
echo -e "B_subtilis_PY79_consensus_5S_rRNA\tJeremy\tregion\t1\t116\t.\t+\t.\tID=B_subtilis_PY79_consensus_5S_rRNA:1..116;Is_circular=false;genome=chromosome;mol_type=genomic DNA;strain=PY79" >> B_subtilis_PY79_consensus_rRNA.gff

# 5S gene
echo -e "B_subtilis_PY79_consensus_5S_rRNA\tJeremy\tgene\t1\t116\t.\t+\t.\tID=gene-consensus_5S_rRNA;Name=consensus_5S_rRNA;gbkey=Gene;gene_biotype=rRNA;locus_tag=consensus_5S_rRNA" >> B_subtilis_PY79_consensus_rRNA.gff

# 5S rRNA
echo -e "B_subtilis_PY79_consensus_5S_rRNA\tJeremy\trRNA\t1\t116\t.\t+\t.\tID=rna-consensus_5S_rRNA;Parent=gene-consensus_5S_rRNA;gbkey=rRNA;locus_tag=consensus_5S_rRNA;product=5S ribosomal RNA" >> B_subtilis_PY79_consensus_rRNA.gff

# 5S exon
echo -e "B_subtilis_PY79_consensus_5S_rRNA\tJeremy\texon\t1\t116\t.\t+\t.\tID=exon-consensus_5S_rRNA-1;Parent=rna-consensus_5S_rRNA;gbkey=rRNA;locus_tag=consensus_5S_rRNA;product=5S ribosomal RNA" >> B_subtilis_PY79_consensus_rRNA.gff

# 16S region
echo -e "B_subtilis_PY79_consensus_16S_rRNA\tJeremy\tregion\t1\t1555\t.\t+\t.\tID=B_subtilis_PY79_consensus_16S_rRNA:1..1555;Is_circular=false;genome=chromosome;mol_type=genomic DNA;strain=PY79" >> B_subtilis_PY79_consensus_rRNA.gff

# 16S gene
echo -e "B_subtilis_PY79_consensus_16S_rRNA\tJeremy\tgene\t1\t1555\t.\t+\t.\tID=gene-consensus_16S_rRNA;Name=consensus_16S_rRNA;gbkey=Gene;gene_biotype=rRNA;locus_tag=consensus_16S_rRNA" >> B_subtilis_PY79_consensus_rRNA.gff

# 16S rRNA
echo -e "B_subtilis_PY79_consensus_16S_rRNA\tJeremy\trRNA\t1\t1555\t.\t+\t.\tID=rna-consensus_16S_rRNA;Parent=gene-consensus_16S_rRNA;gbkey=rRNA;locus_tag=consensus_16S_rRNA;product=16S ribosomal RNA" >> B_subtilis_PY79_consensus_rRNA.gff

# 16S exon
echo -e "B_subtilis_PY79_consensus_16S_rRNA\tJeremy\texon\t1\t1555\t.\t+\t.\tID=exon-consensus_16S_rRNA-1;Parent=rna-consensus_16S_rRNA;gbkey=rRNA;locus_tag=consensus_16S_rRNA;product=16S ribosomal RNA" >> B_subtilis_PY79_consensus_rRNA.gff

# 23S region
echo -e "B_subtilis_PY79_consensus_23S_rRNA\tJeremy\tregion\t1\t2928\t.\t+\t.\tID=B_subtilis_PY79_consensus_23S_rRNA:1..2928;Is_circular=false;genome=chromosome;mol_type=genomic DNA;strain=PY79" >> B_subtilis_PY79_consensus_rRNA.gff

# 23S gene
echo -e "B_subtilis_PY79_consensus_23S_rRNA\tJeremy\tgene\t1\t2928\t.\t+\t.\tID=gene-consensus_23S_rRNA;Name=consensus_23S_rRNA;gbkey=Gene;gene_biotype=rRNA;locus_tag=consensus_23S_rRNA" >> B_subtilis_PY79_consensus_rRNA.gff

# 23S rRNA
echo -e "B_subtilis_PY79_consensus_23S_rRNA\tJeremy\trRNA\t1\t2928\t.\t+\t.\tID=rna-consensus_23S_rRNA;Parent=gene-consensus_23S_rRNA;gbkey=rRNA;locus_tag=consensus_23S_rRNA;product=23S ribosomal RNA" >> B_subtilis_PY79_consensus_rRNA.gff

# 23S exon
echo -e "B_subtilis_PY79_consensus_23S_rRNA\tJeremy\texon\t1\t2928\t.\t+\t.\tID=exon-consensus_23S_rRNA-1;Parent=rna-consensus_23S_rRNA;gbkey=rRNA;locus_tag=consensus_23S_rRNA;product=23S ribosomal RNA" >> B_subtilis_PY79_consensus_rRNA.gff

bedtools sort -i B_subtilis_PY79_consensus_rRNA.gff > B_subtilis_PY79_consensus_rRNA_sorted.gff
mv B_subtilis_PY79_consensus_rRNA_sorted.gff B_subtilis_PY79_consensus_rRNA.gff
