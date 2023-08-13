# Version: 1.1
# Usage:
#   python replace_text.py /Path/dataset.fasta /Path/mapping.csv
# Goal:
#   This Python script read the FASTA (or any dataset) file, and for each line, check if it contains any of the original text. If so, replace it with the corresponding replacement text
# by: Aroob Alhumaidy
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