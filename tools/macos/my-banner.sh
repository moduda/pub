#! /bin/sh
#
# Print the provided string with a box around it to highlight
#
# 30.apr.26     ykim
#

my_banner() {
    local msg="$*"
    local longest=$(echo "$msg" | awk '{ print length($0) }' |
        sort -n | tail -1)
    local edge=$(printf '%*s' "$longest" '' | tr ' ' '-')

    echo "+---${edge}---+"
    echo "$msg" | while read line
        do
            local thislinelen=$(echo "$line" | awk '{ print length($0) }')
            local fillnum=$(($longest - $thislinelen))
            local filler=$(printf '%*s' "$fillnum" '')
            echo "$line$filler" | sed -e "s/.*/|   &   |/"
        done
    echo "+---${edge}---+"
}

my_banner "$@"
