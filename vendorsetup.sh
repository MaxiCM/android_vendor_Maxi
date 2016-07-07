for combo in $(curl -s https://raw.githubusercontent.com/MaxiCM/hudson/master/maxi-build-targets | sed -e 's/#.*$//' | grep maxi-6.0 | awk '{printf "maxi_%s-%s\n", $1, $2}')
do
    add_lunch_combo maxi_serranoltexx-userdebug
done
