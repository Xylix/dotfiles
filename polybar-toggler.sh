#!/bin/sh

# Check if xdo is installed
xdo_path=$(which xdo)
if [ $? -ne 0 ]; then
    echo "Cannot find \`xdo\` command." 1>&2
    exit 1
fi
# Obtain bar's window id
id=$(xdo id -N "Polybar")
# Toggle bar visibility
# I really had no better idea to store the state than using /tmp/
if [ "1" = "$(cat /tmp/polyvar)" ]
then
    xdo hide -N "Polybar"
    echo 0 > /tmp/polyvar
else
    xdo show -N "Polybar"
    echo 1 > /tmp/polyvar
fi
