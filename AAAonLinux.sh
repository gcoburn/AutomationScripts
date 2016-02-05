# BASH Shell Script to be used in vRO on provision
# Replace the {$variables} in this script at execution time

cd /opt

curl -O --insecure https://{$appliance}:5480/service/software/download/prepare_vra_template.sh

chmod 777 ./prepare_vra_template.sh

./prepare_vra_template.sh -n -c vsphere -a {$appliance} -m {$iaas} -s false -j true
