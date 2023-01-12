# Pipeline amp_geo_analysis.sh
Identify geographic location of 16S rRNA amplicon sequences based on blast searches

The pipeline consists of three modules:
1. Blast search and blast output parsing
2. GenBank files download 
3. Extract geographic location from GenBank files



Module 2 - GenBank files download 

To retrieve multiples sequence reports from NCBI using eDirect, the basic command-line is:

for i in $(cat AccNumList.txt $1);  do  esearch -db nucleotide -query $i |
  efetch -format gp > $i.txt; done

This command will create a .txt file with the NCBI sequence reports for each acc. number listed in the AccNumList.txt.
The AccNumList.txt is a scape sequence of AccNums. Here is an example for AccNumList.txt file:

MF438399
MK274089
MH112282
MF689122
KX968160
KF766879
KF766610
KU505310
KX366232
MZ245764
OW842403
LC687133


Here is an example for one NCBI sequence reports:


# LOCUS       MF438399                 441 bp    DNA     linear   ENV 03-DEC-2018
# DEFINITION  Uncultured bacterium clone cafs151 16S ribosomal RNA gene, partial
            sequence.
ACCESSION   MF438399
VERSION     MF438399.1
KEYWORDS    ENV.
SOURCE      uncultured bacterium
  ORGANISM  uncultured bacterium
            Bacteria; environmental samples.
REFERENCE   1  (bases 1 to 441)
  AUTHORS   Reis,M.C., Bagatini,I.L., Vidal,L.O., Bonnet,M.P., Marques,D.M. and
            Hugo,S.
  TITLE     Bacterioplankton spatiotemporal dynamics reflects complexity of the
            Amazon hydrologic network
  JOURNAL   Unpublished
REFERENCE   2  (bases 1 to 441)
  AUTHORS   Reis,M.C., Bagatini,I.L., Vidal,L.O., Bonnet,M.P., Marques,D.M. and
            Hugo,S.
  TITLE     Direct Submission
  JOURNAL   Submitted (04-JUL-2017) Department of Hidrobiology, Laboratory of
            Microbial Processes and Biodiversity, Rodovia Washington Luiz km
            235, Sao Carlos, Sao Paulo 13565-905, Brazil
COMMENT     Sequences were screened for chimeras by the submitter using
            USEARCH.
            
            ##Assembly-Data-START##
            Assembly Method       :: Uparse v. 1.5
            Sequencing Technology :: Illumina
            ##Assembly-Data-END##
FEATURES             Location/Qualifiers
     source          1..441
                     /organism="uncultured bacterium"
                     /mol_type="genomic DNA"
                     /isolation_source="floodplain lake water"
                     /db_xref="taxon:77133"
                     /clone="cafs151"
                     /environmental_sample
                     /country="Brazil"
                     /collection_date="2013"
                     /note="OTU_114"
     rRNA            <1..>441
                     /product="16S ribosomal RNA"
ORIGIN      
        1 cctacgggag gcagcagtgg ggaatcttgc gcaatgggcg aaagcctgac gcagcaacgc
       61 cgcgtgcggg atgaaggcct tcgggttgta aaccgctttc agcagggaag aaaatgacgg
      121 tacctgcaga agaagccccg gccaactacg tgccagcagc cgcggtaaca cgtagggggc
      181 gagcgttgtc cggatttatt gggcgtaaag agctcgtagg cggttcggta agtcgggtgt
      241 gaaacctcca ggctcaacct ggagacgcca cctgatactg ctgtgactcg agtccggtag
      301 gggagtgcgg aactcctggt gtagcggtga aatgcgcaga tatcaggaag aacaccagcg
      361 gcgaaggcgg cactctgggc cggtactgac gctgaggagc gaaagcgtgg gtagcaaaca
      421 ggattagata ccctagtagt c
//
____________________________________________________________________________________________________________________

Entrez Direct (eDirect): E-uilities on the Unix Command Line (https://www.ncbi.nlm.nih.gov/books/NBK179288/)

Install EDirect software.
  Open a terminal window and execute one of the following two command:
  
  $ sh -c "$(curl -fsSL ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"

  $ sh -c "$(wget -q ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh -O -)"

  One installation is complete, run:

  $ export PATH=${PATH}:${HOME}/edirect
    
    to set the PATH for the current terminal session.

NOTE: EDirect runS on Unix and Macintosh and Windows (under the Cygwin Unix-emulation environment) 
____________________________________________________________________________________________________________________


