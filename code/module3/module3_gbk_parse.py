
"""
module3: extract Features information from (multi-)genbank file and create an string that can be printed in a file.
"""


from optparse import OptionParser
from Bio import SeqIO
import sys
import re


def option_parser():
    """Parse arguments from command line."""
    desc = """module3: extract Features information from genbank file and create an string that can be printed in a file."""
    parser = OptionParser(usage="%prog --input_file GenBank",
        description= desc,
        version= "%prog version 1.0")
    parser.add_option("-i", "--input_file",
        metavar = "<FILENAME>",
        action = "store",
        dest = "input_file",
        help = "set <FILENAME> as input GenBank file.")
    (options, args) = parser.parse_args()
    return options.input_file

def extract_features(record):
    
    text = record.format("genbank")
    space = re.compile("\s+|\n")

    #isolation_source
    aux = re.compile(r'/isolation_source="([\w+ ])"\s+/',re.S)
    temp = aux.search(text)
    if temp != None:
        isolation_source = temp.group(1)
    else:
        isolation_source = "Unknown"
    
    #Country
    temp = None
    aux = re.compile(r'/country="(.+)"')
    temp = aux.search(text)
    if temp !=None:
        aux = temp.group(1)
        aux = space.sub(" ",aux)
        country = aux        
    else:
        country = "Unknown"
    
    return isolation_source,country

# Main function

if __name__ == '__main__':
    
    input_file = option_parser()

    with open(input_file, "r") as handle:
        output = ""
        for index, record in enumerate(SeqIO.parse(handle, format = "genbank")):
            id = record.id  # accession number
            desc = record.description # sequence description
            organism = record.annotations["organism"]
            taxonomy = r"|".join(record.annotations["taxonomy"])
            isolation, country = extract_features(record)
            references = ""
            for i in record.annotations["references"]:
                references += f"{i.title}\t{i.journal}\t{i.authors}"
            
            output += f"{id}\t{desc}\t{organism}\t{taxonomy}\t{isolation}\t{country}\t{references}\n"
        print(output)
sys.exit(0)

