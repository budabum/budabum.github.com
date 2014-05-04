get_functions(){
  cat testwar.sh | sed -n /^function/p | sed -e "s|function  *\([^(]*\).*|\1|"
}

function _test_war_completion(){
  # Get current incomplete completion word
  local cur=${COMP_WORDS[COMP_CWORD]}
  # Show completion if one or two words in command line
  if [ ${#COMP_WORDS[*]} -lt 3 ] ; then
    COMPREPLY=( $(compgen -W '`get_functions` FROM_FUNCTION' -- ${COMP_WORDS[COMP_CWORD]}) )
  fi
  return 0
}

complete -F _test_war_completion testwar.sh

