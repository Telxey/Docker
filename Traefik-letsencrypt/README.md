Create basicauth for traefik

    sudo apt update
    sudo apt install apache2-utils

RUN below command to generate basicauth
#### NOTE:
Replace USER with your username and PASSWORD with your password keep inside the " * " to be hashed.

    echo $(htpasswd -nb "USER" "PASSWORD") | sed -e s/\\$/\\$\\$/g

 If you’re having an issue with your password, it might not be escaped properly 
    and you can use the following command to prompt for reset your password

    echo $(htpasswd -nB USER) | sed -e s/\\$/\\$\\$/g
