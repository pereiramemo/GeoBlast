# Pipeline amp_geo_analysis.sh
Identify geographic location of 16S rRNA amplicon sequences based on blast searches

The pipeline consists of three modules:
1. Blast search and blast output parsing
2. GenBank files download 
3. Extract geographic location from GenBank files



## Module 2 - GenBank files download 

To retrieve multiples sequence reports from NCBI using eDirect, the basic command-line is:

    $for i in $(cat AccNumList.txt $1);  do  esearch -db nucleotide -query $i |
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


<img width="556" alt="image" src="https://user-images.githubusercontent.com/65190576/212146230-7724fb38-108a-4a2a-8bf2-0aaa4238cf4c.png">

____________________________________________________________________________________________________________________

Entrez Direct (eDirect): E-uilities on the Unix Command Line (https://www.ncbi.nlm.nih.gov/books/NBK179288/)

Install EDirect software.
  Open a terminal window and execute one of the following two command:

    sh -c "$(curl -fsSL ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"

    sh -c "$(wget -q ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh -O -)"

  One installation is complete, run:
    export PATH=${PATH}:${HOME}/edirect
    
  to set the PATH for the current terminal session.

NOTE: EDirect runS on Unix and Macintosh and Windows (under the Cygwin Unix-emulation environment) 
____________________________________________________________________________________________________________________


