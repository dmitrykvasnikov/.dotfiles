read -p "Do you want to hibernate: y/N? " ans
case "$ans" in
	[yY])
		systemctl hibernate
		;;
	*)
		;;
esac
