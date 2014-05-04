#!/bin/bash

function download(){ echo "Downloads war from CI" ; }

function deploy(){ echo "Deploys war file" ; }

function start(){ echo "Starts server" ; }

function stop(){ echo "Stops server" ; }

get_functions(){
  cat $0 | sed -n /^function/p | sed -e "s|function  *\([^(]*\).*|\1|"
}

show_completion(){
  # Get current incomplete completion word
  local cur=$(echo "$COMP_LINE" | sed -e "s|$0 *.* \([^ ]*\)|\1|")
  # Get number of spaces
  let num=$(echo "$COMP_LINE" | sed -e "s|[^ ]||g" | wc -m)

  # Stop show completion if more than 2 words in $COMP_LINE
  # first word is prog name ($0)
  # second word is completed command followed by space
  if [ $num -lt 3 ] ; then
    compgen -W '`get_functions` FROM_SAME_FILE' -- $cur
  fi
}

run_command(){
  echo "running command '$1'"
  for i in `get_functions` ; do
    if [ "$i" == "$1" ] ; then
      eval $1
      return 0
    fi
  done
  echo "Error: unknown command '$1'"
  return 1
}

do_work(){ [ $# -eq 1 ] && run_command $1 || usage ; }

usage(){ echo "Print usage info..." ; }

# Entry point
[ -n "${SHOW_COMPLETION}" ] && show_completion $@ || do_work $@


