#!/bin/bash

path=" "

for i in $(cat AccNumList.txt $1);  do  esearch -db nucleotide -query $i |
 efetch -format gp > $i.txt; done
