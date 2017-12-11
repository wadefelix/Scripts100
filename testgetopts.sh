#!/bin/sh
# testgetopts.sh -vf /path/to/someFile

red='\033[0;31m'
nocolor='\033[0m'

SELFNAME=$0

show_help() {
    cat <<xxxxxxxxxx
$SELFNAME [-h?v] [-f output_file]
Options:
    -h|-?          help
    -v             verbose
    -f output_file
xxxxxxxxxx
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
output_file=""
verbose=0
while getopts "h?vf:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    v)  verbose=1
        ;;
    f)  output_file=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

echo "verbose=${red}$verbose${nocolor}, output_file='${red}$output_file${nocolor}', Leftovers: ${red}$@${nocolor}"


# End of file
