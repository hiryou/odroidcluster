while true; do
    read -p "Do you wish to install this program? [y/n] " yn
    case $yn in
        [Yy]* ) 
        	echo "name"; 
        	echo "long"; 
        	break;;
        [Nn]* ) break;;
        * ) ;;
    esac
done

while true; do
    read -p "One more? [y/n] " yn
    case $yn in
        [Yy]* ) 
        	echo "long long"; 
        	echo "name name"; 
        	break;;
        [Nn]* ) break;;
        * ) ;;
    esac
done

