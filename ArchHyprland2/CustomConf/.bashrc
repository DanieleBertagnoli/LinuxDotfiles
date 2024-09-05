for f in ~/.config/bashrc/*; do
	if [ ! -d $f ]; then
		source $f
	fi
done
