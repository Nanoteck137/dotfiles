#!/bin/sh

rm $PWD/polybar/launch.sh

./setup_linux.sh
ln -s $PWD/polybar/launch_desktop.sh $PWD/polybar/launch.sh
