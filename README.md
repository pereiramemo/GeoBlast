# GeoBlast pipeline
Identify geographic location of 16S rRNA amplicon sequences based on blast searches

The pipeline consists of three modules:
1. Blast search and blast output parsing
2. GenBank files download 
3. Extract geographic location from GenBank files

### Output

/main folder:  
&emsp;  blout.tsv (row blast output)  
&emsp;  blout_filt.tsv (filtered blast output)  
&emsp;  geoblast_output.tsv (geoblast final output table)  
&emsp;   /\<query_seq\>:  
&emsp;  &emsp; acc2download.txt (list of acc hits to be downloaded)  
&emsp;  &emsp; downloadad.gbk (downloaded gbk files of hits)  
&emsp;  &emsp; query_blout_filt.tsv (section of blout_filt.tsv corresponding to <QUERY>)  
&emsp;  &emsp; parsed_gbk.tsv (parsed fields of gbk files)  



    
    
