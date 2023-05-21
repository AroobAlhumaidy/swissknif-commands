# swissknif-commands
-----------------------------------
# ncbi commandline: 
## case: 
you have a group of acession numbers and you want to download all these sequences locally, all you need to do is: 
### OS: linux

1. install the NCBI Entrez Direct command-line utilities 
```
sh -c "$(curl -fsSL https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"
sh -c "$(wget -q https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh -O -)"
export PATH=${HOME}/edirect:${PATH}
```
2. go to your working directoy
3. create a list that contain the acession numbers of the new sequences:
```
vi new.ref.txt
```
4. use the following command to install all the required sequences: 
```
esearch -db nucleotide -query "$(cat new.ref.txt)" | efetch -format fasta > sequences.fasta
```
5. I highly recommend if you have more than 20 sequences that you split them into chuncks, in order to do that use the following loops to split the acession numbers and run the ncbi command: 
```
for chunk in $(split -d -l 10 new.ref.txt ref_chunk_); do ls ; done 
```
```
for chunk in ref_chunk_*; do esearch -db nucleotide -query "$(cat $chunk)" | efetch -format fasta >> sequences.ncbi.fasta ; done
```

-----------------------------------
# Extract group of sequences from a larg.fasta file: 
## case: 
from the big fasta file i want to only choose the ones in this list only.old.txt and extract the sequences in new file
1. create a txt file with the sequences deflines 
2. run the command: 
    - replace ```deflines.txt``` with your acession list
    - replace ```big.sequences.fasta``` with the name of your big fasta file 
### Option1:
```
grep -Fwf deflines.txt big.sequences.fasta > tt.txt 
awk -v RS=">" -v FS="\n" -v ORS="" 'NR==FNR{a[$1]=$0;}NR>FNR{print ">"a[$1]}' big.sequences.fasta tt.txt |sed 's/>>/>/' > matched.sequences.fasta 
```

------------------------------------
# replace charecters like / on sequence defline or any file: 
```
sed -i '/^>/ s/\//_/g' sequences.fasta

```
------------------------------------
# Manipulating fasta file: 



# References: 
- https://www.ncbi.nlm.nih.gov/books/NBK179288/

------------------------------------
# Blast unknown sequences: 
