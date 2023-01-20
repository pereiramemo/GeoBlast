###############################################################################
### Blast analysis module
###############################################################################

#!/bin/bash

###############################################################################
# 1. set environment
###############################################################################

set -o pipefail

source /home/epereira/workspace/dev/amp_geo_analysis/code/conf.sh

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
--min_len NUM                   minimum alignment length
--nslots NUM                    number of slots (used in BBDuk, UProC, and FragGeneScanPlusPlus) (default 2)
--output_prefix CHAR            prefix output name (default sample name)
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
  --min_len)
  if [[ -n "${2}" ]]; then
    MIN_LEN="${2}"
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
  --overwrite)
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

if [[ ! -a "${INPUT_DB}".nhr ]]; then

  "${blastn}" \
  -in "${INPUT_DB}" \
  -input_type fasta \
  -dbtype nucl \
  -parse_seqids 

  if [[ $? -ne "0" ]]; then
    echo "makeblastdb ${INPUT_DB} failed"
    exit 1
  fi  
  
fi

  
