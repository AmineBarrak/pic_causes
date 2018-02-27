#!/bin/bash

rm $2

while IFS=, read a b
do  
	git checkout $b
	while read f
	do
		ext=$(echo $f| cut -d'.'  -f2)
		# echo $ext
		if [[ $ext == *"php"* ]]; then
			#statements
			# echo $f
			cmd=$(git blame $f)
			if [[ $cmd ]]; then
				#statements
				while read c
				do
					echo "$a,$b,$f,$c" >> $2

				done < <(git blame $a..$b -- $f |grep -v "^^"| cut -c-11 | sort -u)
			else
				cm=$(git log -2 --oneline -- $f | cut -d' ' -f1 | tail -1)
				while read c
				do
					echo "$a,$b,$f,$c" >> $2

				done < <(git blame $a..$cm -- $f |grep -v "^^"| cut -c-11|  sort -u)

			fi
			
		fi
		

	done < <(git diff --name-only $a $b)

	# echo $a 

done< $1


# git blame 2.3.1..2.3.2 -L1698,+1 -- xmlrpc.php