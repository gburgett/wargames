#! /bin/bash

ED='\033[0;31m'
LRED='\033[1;31m'
LGRAY='\033[0;37m'
LGREEN='\033[1;32m'
NC='\033[0m'

GAME='bandit'
while getopts ":g:l:" opt; do
  case $opt in
    g)
      GAME=$OPTARG
      ;;
    l)
      LEVEL=$OPTARG
      ;;
   \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

passwords=`cat ./$GAME.txt`
USER=""
PW=""
LVL=-1
while IFS=':' read -ra LINE; do
  [[ -z "$LINE" ]] && continue;
  if [[ ! -z "$LEVEL" ]]; then
    if [[ "${LINE[0]}" -eq "$LEVEL" ]]; then
      
      USER=${LINE[1]}
      PW=${LINE[2]}
      LVL=${LINE[0]}
      break
    fi
  fi

  if [[ ${LINE[0]} -gt $LVL ]]; then
    
    USER=${LINE[1]}
    PW=${LINE[2]}
    LVL=${LINE[0]}
  fi

done <<< "$passwords"

echo -e "Entering level $LVL of $GAME.  Password is: ${LGREEN}${PW}${NC}"
echo $PW | xclip

ssh -p 2220 $USER@bandit.labs.overthewire.org
