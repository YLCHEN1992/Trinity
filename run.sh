
fastp -i ${1} \
 -o ${1}_R1_clean.fastq.gz \
 -I ${2} \
 -O ${2}_R2_clean.fastq.gz \
 -j A1.json \
 -h A1.html
 
Trinity --seqType fq \
--left $1  \
--right $2 \
--CPU 8 \
--max_memory 72G

TransDecoder.LongOrfs -t target_transcripts.fasta

hisat2-build -p 16 trinity_out_dir.Trinity.fasta trinity_index

hisat2 -p 16 -x trinity_index \
-1 03190023-1-A-2_S98_L007_R1_clean.fastq.gz \
-2 03190023-1-A-2_S98_L007_R2_clean.fastq.gz \
-S A2.sam

featureCounts -a trinity_out_dir.Trinity.fasta.transdecoder_dir/longest_orfs.gff3 \
-T 16 \
-p --countReadPairs \
-g ID -t exon \
-o allsum.count \
A1.sam A2.sam A3.sam B1.sam B2.sam B3.sam C1.sam C2.sam C3.sam 

makeblastdb -in rna.fna -dbtype nucl
blastn -query trinity_out_dir.Trinity.fasta \
-db ../referencedata/rna.fna \
-out blastnout.txt \
-evalue 1e-5 -outfmt 7
