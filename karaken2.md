# Validate raw data
```sh
start_time=$SECONDS
docker run --rm -v $(pwd):/home/data -w /home/data nanozoo/seqkit:latest seqkit seq --threads 300 -v {sampleID}.fq.gz > {sampleID}.v.fq
elapsed_time=$(($SECONDS - $start_time))
echo "{sampleID}. Validate raw data: $elapsed_time seconds" >> {sampleID}.benchmark.txt
```

# gzip the validated raw data
```sh
start_time=$SECONDS
gzip {sampleID}.v.fq
elapsed_time=$(($SECONDS - $start_time))
echo "{sampleID}. gzip the validated raw data: $elapsed_time seconds" >> {sampleID}.benchmark.txt
```

# Karaken2
```sh
cd <working directory>

start_time=$SECONDS
docker run --rm -v $(pwd):/home/data -v PATH/Kraken_Database:/home/data/database -w /home/data staphb/kraken2:latest kraken2 --threads 300 --gzip-compressed --db /home/data/database --report {sampleID}.K2_report --use-names --output {sampleID}.K2_output {sampleID}.v.fq.gz
elapsed_time=$(($SECONDS - $start_time))
echo "{sampleID}. Karaken2: $elapsed_time seconds" >> {sampleID}.benchmark.txt
```

# Pavian (Karaken or any metagenomics report visualization)

for installation check https://github.com/fbreitwieser/pavian 

# Karaken extract
```sh
start_time=$SECONDS
docker run --rm -v $(pwd):/data -w /data/ nanozoo/krakentools:1.2--13d5ba5 extract_kraken_reads.py \
-k {sampleID}.K2_output \
-r {sampleID}.K2_report \
-s {sampleID}.v.fq.gz \
-o {sampleID}.v.extracted.fq.gz \
-t <TaxaID> --include-parents --include-children --fastq-output
elapsed_time=$(($SECONDS - $start_time))
echo "{sampleID}. Karaken Extract: $elapsed_time seconds" >> $SLURM_JOB_ID.{sampleID}.benchmark.txt
```
- <TaxaID>  = the taxa id of the organism of interest 

# gzip the fastq file 
if the previous step output not compressed use the following command
```sh
gzip {sampleID}.v.extracted.fq
```