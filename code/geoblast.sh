###############################################################################
### Geo Blast Piepeline
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
--min_len NUM                   minimum alignment length
--e_val NUM                     e-value
--nslots NUM                    number of slots (default 2)
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
# 4. Check input data
###############################################################################

if [[ ! -f "${INPUT}" ]]; then
  echo "Input file missing"
  exit 1
fi

if [[ ! -f "${INPUT_DB}" ]]; then
  echo "Input db files missing"
  exit 1
fi

###############################################################################
# 5. Check output directories
###############################################################################

if [[ -d "${OUTPUT_DIR}" ]]; then
  if [[ "${OVERWRITE}" != "t" ]]; then
    echo "${OUTPUT_DIR} already exist. Use \"--overwrite t\" to overwrite."
    exit
  fi
  
  if [[ "${OVERWRITE}" == "t" ]]; then
    rm -r "${OUTPUT_DIR}" & mkdir -p "${OUTPUT_DIR}" 
    if [[ $? -ne "0" ]]; then
      echo "Failed to remove and create new output directory ${OUTPUT_DIR}"
      exit 1
    fi  
  fi
fi

###############################################################################
# 5. Define defaults
###############################################################################

if [[ -z "${MIN_ID}" ]]; then
  MIN_ID="99"
fi

if [[ -z "${MIN_LEN}" ]]; then
  MIN_LEN="200"
fi

if [[ -z "${EVALUE}" ]]; then
  EVALUE="1e-5"
fi

if [[ -z "${NLSOTS}" ]]; then
  NLOSTS="4"
fi

if [[ -z "${SAMPLE_NAME}" ]]; then
  SAMPLE_NAME=$(basename "${INPUT}" | sed -e "s/.fasta//" -e "s/.fa//")
fi

###############################################################################
# 6. Run module1: blastn search
###############################################################################

"${CODE}"/module1_blast_search.sh \
--input "${INPUT}" \
--input_db "${INPUT_DB}" \
--min_id "${MIN_ID}" \
--min_len "${MIN_LEN}" \
--e_value "${EVALUE}" \
--nslots "${NSLOTS}" \
--output_dir "${OUTPUT_DIR}"

if [[ ! -f "${INPUT}" ]]; then
  echo "module1_blast_search.sh ${i} failed"
  exit 1
fi

###############################################################################
# 7. Run module2: gbk download
###############################################################################

"${CODE}"/module2_gbk_download.sh \
--input "${INPUT}" \
--nslots "${NSLOTS}" \
--output_dir "${OUTPUT_DIR}"

if [[ ! -f "${INPUT}" ]]; then
  echo "module2_gbk_download.sh ${i} failed"
  exit 1
fi


