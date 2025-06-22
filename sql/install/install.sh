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
    ""        "sql/install/create_db.sql" "Creating database '$db'..."
    "$db"     "sql/install/create_log.sql" "Creating log pocedures"
    "$db"     "sql/install/drop_tables.sql" "Deleating tables"
    "$db"     "sql/install/create_user.sql" "Creating database user '$user'..."
    "$db"     "sql/install/create_customer.sql" "Creating 'Customer' table..."
    "$db"     "sql/install/create_notice.sql" "Creating 'Notice' table..."
    "$db"     "sql/install/create_product_category.sql" "Creating 'Product Category' table..."
    "$db"     "sql/install/create_product.sql" "Creating 'Product' table..."
    "$db"     "sql/install/create_purchase.sql" "Creating 'Purchase' table..."
    "$db"     "sql/install/create_purchase_item.sql" "Creating 'Purchase Item' table..."
    "$db"     "sql/install/create_customer_order.sql" "Creating 'Customer Order' table..."
    "$db"     "sql/install/create_transaction.sql" "Creating 'Transaction' table..."
    "$db"     "sql/add_transaction.sql" "Creating 'Creating AddTransaction' function..."
    "$db"     "sql/del_transaction.sql" "Creating 'Creating DelTransaction' function..."
    "$db"     "sql/edit_transaction.sql" "Creating 'Creating EditTransaction' function..."
    "$db"     "sql/set_order.sql" "Creating 'Creating SetOrder' function..."
    "$db"     "sql/set_order_payment.sql" "Creating 'Creating SetOrderPayment' function..."
EOF

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
echo "pwd: $PWD"
regex='\"([^\"]*?)\"[ \t]+\"([^\"]+?)\"([ \t]+\"([^\"]+?)\")?'
# regex='\"([^\"]*?)\"[ \t]+\"([^\"]*?)\"[ \t]+\"([^\"]+?)\"([ \t]+\"([^\"]+?)\")?'
while IFS= read -r row; do
    [[ $row =~ $regex ]]
    connect=${BASH_REMATCH[1]:=""}
    path=${BASH_REMATCH[2]:="${RED}not specified${NC}"}
    description=${BASH_REMATCH[4]:="Unnamed SQL script..."}
    echo ""
    echo -e "$description"
    echo -e "\t${GRAY}from file:${NC} $path"
    install -D "$path" "/tmp/$path"
    if [ -z "$connect" ]; then
        sudo -u "postgres" psql --echo-errors -a -f "/tmp/$path"
    else
        echo -e "\t${GRAY}connect to database:${NC} $connect"
        sudo -i -u "postgres" psql --echo-errors --dbname=$connect -a -f "/tmp/$path"
        # sudo -i -u "$user" psql --echo-errors --dbname=$connect -a -f "/tmp/$path"
    fi
done <<< "$scripts"
#
# Removing temporary user and files 
sudo deluser "$user" sudo
sudo deluser --remove-home "$user"
# rm ~/.pgpass