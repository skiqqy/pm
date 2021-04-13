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
	declare -A backups # Machines we will be backing up too
	titles=( ) # Parallel array
	passw=( ) # Parallel array

	# Get Passwords and thier titles
	while read -r group
	do
		for pass in "$group"/*.gpg
		do
			title=${pass/$disk\//}
			title=${title/\.gpg/}
			password=$(pass "$title")
			if [[ $title =~ ^Backups/ ]]
			then
				# We dont backup the addresses and passwords of our backup machines
				backups[$(basename "$title")]="$password"
			else
				titles+=( "$title" )
				passw+=( "$password" )
			fi
		done
	done < <(find "$disk" -type d)

	# Now comes the scuffed part, backup on each machine in a single ssh session
	for server in "${!backups[@]}"
	do
		# ssh to the server and backup.
		sshpass -p "${backups[$server]}" ssh -t "$server" \
		"
		echo Starting Backup on $server ...
		titles=( ${titles[*]} ) # Unpack the data
		passw=( ${passw[*]} )
		i=0
		for t in \${titles[*]}
		do
			echo \"Backing up \$t...\"
			echo \${passw[\$i]} | pass add -fm \"\$t\" > /dev/null
			((i++))
		done
		titles=( ) # Clear the data
		passw=( )  # Clear the data
		echo Finished.
		"
	done
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
