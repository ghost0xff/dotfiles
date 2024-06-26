#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
#
## Available Styles
#
## style-1     style-2     style-3     style-4     style-5
## style-6     style-7     style-8     style-9     style-10
## style-11    style-12    style-13    style-14    style-15

dir="$HOME/.config/rofi/launchers/type-emoji"
theme='style-3'

## Run

chosen=$(cut -d ';' -f1 ~/.local/share/unicode/emojis | \
        rofi  -dmenu -p "Emoji picker" -theme ${dir}/${theme}.rasi | \
        sed "s/\ .*//" )


[ -z "$chosen" ] && exit

printf "%s" "$chosen" | wl-copy 
notify-send "'$chosen' copied to clipboard." --app-name="Emoji picker" 


