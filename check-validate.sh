echo 'packer validate app:'
echo $(packer validate -var-file=packer/variables.json packer/app.json)
echo '--------------------'
echo 'packer validate db:'
echo $(packer validate -var-file=packer/variables.json packer/db.json)
echo '--------------------'
echo 'terraform validate stage:'
echo $(cd terraform/stage/ && terraform validate)
echo '--------------------'
echo 'terraform validate prod:'
echo $(cd terraform/prod/ && terraform validate)
