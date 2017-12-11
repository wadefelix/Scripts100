#!/bin/bash

# http://stackoverflow.com/a/29754866
# testgetopt.sh -vfd /path/to/someFile -o /path/to/someOtherFile
# testgetopt.sh -v -f -d -o/path/to/someOtherFile -- /path/to/someFile
# testgetopt.sh --verbose --force --debug /path/to/someFile -o/path/to/someOtherFile
# testgetopt.sh --output=/path/to/someOtherFile /path/to/someFile -vfd
# testgetopt.sh /path/to/someFile -df -v --output /path/to/someOtherFile

red='\033[0;31m'
nocolor='\033[0m'

# debuginfo
echo -e "$0 需要处理的参数: $red$@$nocolor"

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "I’m sorry, $red`getopt --test`$nocolor failed in this environment."
    exit 1
fi

SHORT=dfo:v
LONG=debug,force,output:,verbose

# -temporarily store output to be able to check for errors
# -activate advanced mode getopt quoting e.g. via “--options”
# -pass arguments only via   -- "$@"   to separate them correctly
PARSED=$(getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi

# debuginfo
echo -e "经过 getopt 处理后\$@不变 $red\$@=$@$nocolor"
# debuginfo
echo -e "但 getopt 的返回值是 $red\$PARSED=$PARSED$nocolor"

# use eval with "$PARSED" to properly handle the quoting
eval set -- "$PARSED"
# debuginfo
echo -e "再经过 $red'eval set -- \"\$PARSED\"'$nocolor 执行后\$@就变成了 $red\$@=$@$nocolor"

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -d|--debug)
            d=y
            shift
            ;;
        -f|--force)
            f=y
            shift
            ;;
        -v|--verbose)
            v=y
            shift
            ;;
        -o|--output)
            outFile="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

# handle non-option arguments
if [[ $# -ne 1 ]]; then
    echo "$red$0: A single input file is required.$nocolor"
    exit 4
fi

echo -e '经过while循环case选择，最后的解析结果'
echo -e "verbose: ${red}$v$nocolor, force: ${red}$f$nocolor, debug: ${red}$d$nocolor, in: ${red}$1$nocolor, out: ${red}$outFile$nocolor"
