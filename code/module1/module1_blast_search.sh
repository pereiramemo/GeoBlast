###############################################################################
### Blast analysis module
###############################################################################

#!/bin/bash

###############################################################################
# 1. set environment
###############################################################################

set -o pipefail

source /home/epereira/workspace/dev/geoblast/code/conf.sh

###############################################################################
# 2. Define help
###############################################################################

show_usage(){
  cat <<EOF
Usage: ./module1_blast_search.sh 
--help                          print this help
--input CHAR                    input fasta file
--input_db CHAR                 input data base
--min_id NUM                    minimum percentage of identity
--min_perc_len NUM              minimum alignment percentage length
--nslots NUM                    number of slots (default 4)
--output_dir CHAR               output dir name 
--overwrite t|f                 overwrite current directory (default f)
--sample_name CHAR              sample name (default input file name)
EOF
}

###############################################################################
# 3. Parse input parameters
###############################################################################

while :; do
  case "${1}" in
    --help) # Call a "show_help" function to display a synopsis, then exit.
    show_usage
    exit 1;
    ;;
#############
  --input)
  if [[ -n "${2}" ]]; then
    INPUT="${2}"
    shift
  fi
  ;;
#############
  --input_db)
  if [[ -n "${2}" ]]; then
    INPUT_DB="${2}"
    shift
  fi
  ;;

#############
  --min_id)
  if [[ -n "${2}" ]]; then
    MIN_ID="${2}"
    shift
  fi
  ;;
#############
  --min_perc_len)
  if [[ -n "${2}" ]]; then
    MIN_PERC_LEN="${2}"
    shift
  fi
  ;;
#############
  --e_value)
  if [[ -n "${2}" ]]; then
    EVALUE="${2}"
    shift
  fi
  ;;  
#############
  --nslots)
  if [[ -n "${2}" ]]; then
    NSLOTS="${2}"
    shift
  fi
  ;;  
#############
  --output_dir)
  if [[ -n "${2}" ]]; then
    OUTPUT_DIR="${2}"
    shift
  fi
  ;;    
#############
  --overwrite)
  if [[ -n "${2}" ]]; then
    OVERWRITE="${2}"
    shift
  fi
  ;;
#############
  --sample_name)
  if [[ -n "${2}" ]]; then
    SAMPLE_NAME="${2}"
    shift
  fi
  ;;  
############ End of all options.
  --)       
  shift
  break
  ;;
  -?*)
  printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
  ;;
  *) # Default case: If no more options, then break out of the loop.
  break
  esac
  shift
done

###############################################################################
# 4. Format databse (if needed)
###############################################################################

if [[ ! -a "${INPUT_DB}".nhr ]]; then

  "${makeblastdb}" \
  -in "${INPUT_DB}" \
  -input_type fasta \
  -dbtype nucl \
  -parse_seqids 

  if [[ $? -ne "0" ]]; then
    echo "makeblastdb ${INPUT_DB} failed"
    exit 1
  fi  
  
fi
  
###############################################################################
# 5. Run blast
###############################################################################

"${blastn}" \
-query "${INPUT}" \
-out ${OUTPUT_DIR}/${SAMPLE_NAME}.blout \
-db "${INPUT_DB}" \
-evalue "${EVALUE}" \
-outfmt "6 qseqid sseqid pident qlen slen length evalue" \
-num_threads "${NSLOTS}" 

if [[ $? -ne "0" ]]; then
  echo "blastn ${INPUT} vs ${INPUT_DB} failed"
  exit 1
fi

###############################################################################
# 6. Filter blout file
###############################################################################

awk -v min_perc_len="${MIN_PERC_LEN}" \
    -v min_id="${MIN_ID}" \
'{ 

  pident=$3
  qlen=$4
  len=$6
  pqlen = 100*len/qlen
  
  if (pident >= min_id && pqlen >= min_perc_len ) {
    print $0
  }

}' "${OUTPUT_DIR}/${SAMPLE_NAME}.blout" > \
   "${OUTPUT_DIR}/${SAMPLE_NAME}_filt.blout"

if [[ $? -ne "0" ]]; then
  echo "awk filtering blout file failed"
  exit 1
fi  

###############################################################################
# 7. Extract outputs
###############################################################################

# create a dir for each query sequence

gawk -v OUTPUT_DIR="${OUTPUT_DIR}" \
'BEGIN {query_id_prev = ""} {

query_id=$1
subject_id=$2
subject2query[query_id][subject_id]=1

if (query_id != query_id_prev) {
  system("mkdir " OUTPUT_DIR"/"query_id)
}

print $0 >> OUTPUT_DIR"/"query_id"/"query_id".blout"

query_id_prev = query_id

} END {

  for (query_id in subject2query) {
    for (subject_id in subject2query[query_id]) {
    
      subject_id = gensub(/\..*/,"","g",subject_id)
      print subject_id >> OUTPUT_DIR"/"query_id"/"query_id"_acc.txt"
      
    }
  } 
}' "${OUTPUT_DIR}/${SAMPLE_NAME}_filt.blout"

if [[ $? -ne "0" ]]; then
  echo "awk command failed"
fi  
