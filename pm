#!/bin/bash
# Password Manager/Wrapper

usage ()
{
	cat << EOF
TODO ~ Describe usage
EOF
	exit "$1"
}

backup ()
{
	disk="$HOME/.password-store"
	while read -r group
	do
		for pass in "$group"/*.gpg
		do
			title=${pass/$disk\//}
			title=${title/\.gpg/}
			password=$(pass "$title")
			echo "$title:$password"
		done
	done < <(find "$disk" -type d)
}

main ()
{
	opts=h
	while getopts "$opts" opt
	do
		case "$opt" in
			h)
				usage 0
				;;
			*)
				usage 1
				;;
		esac
	done

	if [[ $1 = backup ]]
	then
		backup
	else
		pass "$@"
	fi
}

main "$@"
