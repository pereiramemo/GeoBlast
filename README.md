# GeoBlast pipeline
Identify geographic location of 16S rRNA amplicon sequences based on blast searches

The pipeline consists of three modules:
1. Blast search and blast output parsing
2. GenBank files download 
3. Extract geographic location from GenBank files

### Install

GeoBlast runs with [Docker](https://www.docker.com/) or [Singularity](https://sylabs.io/). 
To install it simply download the one of these two wrap scripts:  
Docker: [geoblast_runner.sh](https://raw.githubusercontent.com/pereiramemo/GeoBlast/main/docker/geoblast_runner.sh)  
Singularity: [geoblast_runner.sh](https://raw.githubusercontent.com/pereiramemo/GeoBlast/main/singularity/geoblast_runner.sh)  

### Usage
```
Usage: geoblast_runner.bash <input file> <output directory> <options>
--help                          print this help
--min_id NUM                    minimum percentage of identity
--min_perc_len NUM              minimum alignment percentage length
--e_val NUM                     e-value
--nslots NUM                    number of slots (default 2)
--overwrite t|f                 overwrite current directory (default f)
--sample_name CHAR              sample name (default input file name)
```
### Output

/main folder:  
&emsp;  blout.tsv (row blast output)  
&emsp;  blout_filt.tsv (filtered blast output)  
&emsp;  **geoblast_output.tsv** (geoblast final output table)  
&emsp;   /\<QUERY\>:  
&emsp;  &emsp; acc2download.txt (list of acc hits to be downloaded)  
&emsp;  &emsp; downloadad.gbk (downloaded gbk files of hits)  
&emsp;  &emsp; query_blout_filt.tsv (section of blout_filt.tsv corresponding to \<QUERY\>)  
&emsp;  &emsp; parsed_gbk.tsv (parsed fields of gbk files)  


    
    
