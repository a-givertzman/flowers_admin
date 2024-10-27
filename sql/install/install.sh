#!/bin/bash
# 
# Deb package postinst script for API Server
#
# source /etc/cma-history/conf
source ./sql/install/conf
############ LIST OF SQL SCRIPTS TO BE EXECUTED ############
# list of SQL scripts to be executed in the format:
# 	<database> <path to sql script> [description]
read -r -d '' scripts << EOF
    ""      "sql/install/create_db.sql" "Creating database '$db'..."
    ""      "sql/install/create_user.sql" "Creating database user '$user'..."
EOF
    # ""      "/etc/cma-history/create_grant_user.sql" "Grant user '$user' to access database '$db'..."
    # "$db"   "/etc/cma-history/create_tags.sql" "Creating 'tags' table..."
    # "$db"   "/etc/cma-history/create_event.sql" "Creating 'event' table..."
    # "$db"   "/etc/cma-history/create_event_view.sql" "Creating 'event_view' view..."

############ INSTALLATION ACTIONS ############
RED='\033[0;31m'
BLUE='\033[0;34m'
GRAY='\033[1;30m'
NC='\033[0m' # No Color
# echo -e ""
# echo -e "POST INST called with: \ntarg1: $1\ntarg2: $2\ntarg3: $3\ntarg4: $4" 
############ LOAD TO DB VIA PSQL ############
echo -e "\t${GRAY} creating temporary user${NC} '$user'..."
sudo adduser --gecos "" --disabled-password "$user" --ingroup sudo
echo -e "\t${GRAY} setting pass for temporary user${NC}..."
sudo chpasswd <<<"$user:$pass"
regex='\"([^\"]*?)\"[ \t]+\"([^\"]+?)\"([ \t]+\"([^\"]+?)\")?'
# regex='\"([^\"]*?)\"[ \t]+\"([^\"]*?)\"[ \t]+\"([^\"]+?)\"([ \t]+\"([^\"]+?)\")?'
while IFS= read -r row; do
    [[ $row =~ $regex ]]
    connect=${BASH_REMATCH[1]:=""}
    path=${BASH_REMATCH[2]:="${RED}not specified${NC}"}
    description=${BASH_REMATCH[4]:="Unnamed SQL script..."}
    echo ""
    echo "pwd: $PWD"
    echo -e "$description"
    echo -e "\t${GRAY}from file:${NC} $path"
    install -D "$path" "/tmp/$path"
    if [ -z "$connect" ]; then
        sudo -u "postgres" psql --echo-errors -a -f "/tmp/$path"
    else
        echo -e "\t${GRAY}connect to database:${NC} $connect"
        sudo -i -u "$user" psql --echo-errors --dbname=$connect -a -f "tmp/$path"
    fi
done <<< "$scripts"
#
# Removing temporary user and files 
sudo deluser "$user" sudo
sudo deluser --remove-home "$user"
# rm ~/.pgpass