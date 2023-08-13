# swissknif-commands
-----------------------------------
# ncbi commandline: 
## case: 
you have a group of acession numbers and you want to download all these sequences locally, all you need to do is: 
### OS: linux

1. install the NCBI Entrez Direct command-line utilities 
```sh
sh -c "$(curl -fsSL https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"
sh -c "$(wget -q https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh -O -)"
export PATH=${HOME}/edirect:${PATH}
```
2. go to your working directoy
3. create a list that contain the acession numbers of the new sequences:
```sh
vi new.ref.txt
```
4. use the following command to install all the required sequences: 
```sh
esearch -db nucleotide -query "$(cat new.ref.txt)" | efetch -format fasta > sequences.fasta
```
5. I highly recommend if you have more than 20 sequences that you split them into chuncks, in order to do that use the following loops to split the acession numbers and run the ncbi command: 
```sh
for chunk in $(split -d -l 10 new.ref.txt ref_chunk_); do ls ; done 
```
```sh
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
```sh
grep -Fwf deflines.txt big.sequences.fasta > tt.txt 
awk -v RS=">" -v FS="\n" -v ORS="" 'NR==FNR{a[$1]=$0;}NR>FNR{print ">"a[$1]}' big.sequences.fasta tt.txt |sed 's/>>/>/' > matched.sequences.fasta 
```

------------------------------------
# replace charecters like / on sequence defline or any file: 
```sh
sed -i '/^>/ s/\//_/g' sequences.fasta

```
------------------------------------
# Manipulating fasta file: 



# References: 
- https://www.ncbi.nlm.nih.gov/books/NBK179288/

------------------------------------
# Blast unknown sequences: 
1. follow the steps here to install BLAST+ commandline tools: 
https://blast.ncbi.nlm.nih.gov/doc/blast-help/downloadblastdata.html#downloadblastdata

------------------------------------
# Rename files:
```sh
rename 's/oldName/newName/' *.fasta
```
------------------------------------
# Simple Loop
```sh
samples=(
  V00000_40
  V00000_39
)

for sample in "${samples[@]}"; do
  echo "Processing sample: $sample"
  start_time=$SECONDS
  <Write commands here>
  echo "Elapsed time: $elapsed_time seconds"
  echo "Sample $sample processed"
done
```
------------------------------------
# Render jupyter notebook:
```sh
jupyter nbconvert --to html --TemplateExporter.exclude_input=True report.ipynb 
```
------------------------------------
# Text replacement in large dataset:
### Step 1: Create the `mapping.csv` File 

First, create a CSV file that contains 2 columns (original,replacement). You can create this file using a text editor or a spreadsheet application like Excel. 
Here's an example of what the `mapping.csv` file might look like:
```csv
original,replacement
value1,value2
value4,value5,
```
### Step 2: create the following Python Script
Save the Python script provided as a file, such as `replace_text.py`
- This Python script read the FASTA (or any dataset) file, and for each line, check if it contains any of the original text. If so, replace it with the corresponding replacement text
- You can find the script ready to use in this repositoy [replace_text.py](https://github.com/AroobAlhumaidy/swissknif-commands/blob/44785196366e9a8adc164aeb9fe02aa433b7bcd2/scripts/replace_text.py) 
```python
import csv
import sys

def main(fasta_file_path, csv_file_path):
    # Read the original and replacement mappings from the CSV file
    mappings = {}
    with open(csv_file_path, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            original = row['original']
            replacement = row['replacement']
            mappings[original] = replacement

    # Read the FASTA file and replace the text as per the mapping
    with open(fasta_file_path, 'r') as file:
        lines = file.readlines()

    with open(fasta_file_path, 'w') as file:
        for line in lines:
            for original, replacement in mappings.items():
                line = line.replace(original, replacement)
            file.write(line)

    print("Replacement done successfully!")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <path/to/fasta/file> <path/to/csv/file>")
        sys.exit(1)

    fasta_file_path = sys.argv[1]
    csv_file_path = sys.argv[2]

    main(fasta_file_path, csv_file_path)
```

### Step 3: Run the Script from the Command Line
Open a terminal or command prompt, navigate to the directory where you saved the script and your FASTA file, and run the following command:
```bash
python replace_text.py /Path/dataset.fasta /Path/mapping.csv
```
Make sure to replace `/Path/dataset.fasta` with the path to your actual FASTA file, and `/Path/mapping.csv` with the path to your actual CSV file if they are in different directories.

### Notes
This script will read the FASTA file and replace all occurrences of the original text with the corresponding replacement text. The changes will be made directly in the original FASTA file. Make sure to have a backup copy of the original file in case you need to revert the changes.