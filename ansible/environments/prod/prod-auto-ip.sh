#!/bin/bash
OLD_APP_EX_IP=$(grep -oP 'appserver ansible_host=\K.*' inventory)
OLD_DB_EX_IP=$(grep -oP 'dbserver ansible_host=\K.*' inventory)
OLD_DB_IN_IP=$(grep -oP 'db_host: \K.*' group_vars/app)

APP_EX_IP=$(cd ../../../terraform/prod/ && terraform show | grep external_ip_address_app | awk '{ print $3 }')
DB_EX_IP=$(cd ../../../terraform/prod/ && terraform show | grep external_ip_address_db | awk '{ print $3 }')
DB_IN_IP=$(cd ../../../terraform/prod/ && terraform show | grep internal_ip_address_db | awk '{ print $3 }' | sed 's/.*"\([^"]*\)".*/\1/')

echo "Старые IP $OLD_APP_EX_IP, $OLD_DB_EX_IP, $OLD_DB_IN_IP"
echo "Новые IP $APP_EX_IP, $DB_EX_IP, $DB_IN_IP"

sed -i -e "s#${OLD_APP_EX_IP}#${APP_EX_IP}#g" ./inventory
sed -i -e "s#${OLD_DB_EX_IP}#${DB_EX_IP}#g" ./inventory
sed -i -e "s#${OLD_DB_IN_IP}#${DB_IN_IP}#g" ./group_vars/app
