#!/bin/bash

for paire in ../sorted/pic_wordpress/*
do 
	v1=$(echo $paire | cut -d'/' -f4 | rev | cut -c9- | rev | cut -d'-' -f2)
	v2=$(echo $paire | cut -d'/' -f4 | rev | cut -c9- | rev | cut -d'-' -f3)
	git checkout $v2
	while IFS=' ' read a f line
	do 

		cmd=$(git blame $f)
		if [[ $cmd ]]; then
			if [[ $a == "DEL" ]]; then
				# echo "dell"
				string=$(git blame $v1..$v2 --reverse -L $line,+1 -- $f | cut -d')' -f2-)
				st=$(echo $string | sed 's/^ *//g')
				comit=$(git log $v1..$v2 --oneline -S "$st" -- $f | cut -c-10 | head -1)

			elif [[ $a == "ADD" ]]; then
				# echo "add"
				comit=$(git blame $v1..$v2 -L $line,+1 -- $f  | cut -c-10)

			fi
		else
			# echo "inexiaastant"
			comit=$(git log -1 --oneline -- $f | cut -d' ' -f1)
		fi

		echo "$v1,$v2,$a,$f,$line,$comit"
		

	done < $paire

done