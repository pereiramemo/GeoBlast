# GeoBlast pipeline
Identify geographic location of 16S rRNA amplicon sequences based on blast searches

The pipeline consists of three modules:
1. Blast search and blast output parsing
2. GenBank files download 
3. Extract geographic location from GenBank files

### Output

/main folder:  
&emsp;  blast raw  
&emsp;  blast filtered  
&emsp;  output table  
&emsp;   /ASV:  
&emsp;  &emsp; acc2download.txt  
&emsp;  &emsp;  downloadad.gbk  
&emsp;  &emsp;  blast filtered  
&emsp;  &emsp;  parsed_gbk.tsv__ 
    
    
