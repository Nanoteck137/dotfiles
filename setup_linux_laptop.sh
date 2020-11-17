#!/bin/sh

rm $PWD/polybar/launch.sh

./setup_linux.sh
ln -s $PWD/polybar/launch_laptop.sh $PWD/polybar/launch.sh
