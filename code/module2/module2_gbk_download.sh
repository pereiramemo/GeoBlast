###############################################################################
### GBK download module
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
Usage: ./module2_gbk_downlaod.sh 
--help                          print this help
--input CHAR                    input acc list
--nslots NUM                    number of slots (default 4)
--output_dir CHAR               output dir name 
--overwrite t|f                 overwrite current directory (default f)
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
  echo "Input acc list missing"
  exit 1
fi

###############################################################################
# 5. Download
###############################################################################

for i in $(cat "${INPUT}"); do
  "${esearch}" -db nucleotide -query "${i}" | \
  "${efetch}" -format gp > "${OUTPUT_DIR}"/"${i}".gbk
  echo 
  if [[ ! -f "${INPUT}" ]]; then
    echo "Download ${i} failed"
    exit 1
  fi
  
done

# for i in $(cat AccNumList.txt $1);  do  esearch -db nucleotide -query $i |
#  efetch -format gp > $i.txt; done
