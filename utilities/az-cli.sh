#type . [file location]/rg-create.sh in bash shell 
#to register all the functions before calling them.

RgCreate() {
    echo Creating resource group $1 ..
    echo
    az group create \
    --name $1 \
    --location $2
    
    echo Resource group created.
}

RgDelete() {
    echo Deleting resource group $1 ..
    echo
    az group delete --name $1 --yes
    
    echo Resource group deleted.
}

VmLinCreate() {
    echo Creating Linux VM $2 ..
    echo
    az vm create \
    --resource-group $1 \
    --name $2 \
    --image $3 \
    --admin-username $4 \
    --authentication-type "ssh" \
    --generate-ssh-keys \
    --public-ip-sku Standard

    echo Linux VM created.
# Linux vm images UbuntuLTS
}

VmWinCreate() {
    echo Creating Windows VM $2 ..
    echo
    az vm create \
    --resource-group $1 \
    --name $2 \
    --image $3 \
    --admin-username $4 \
    --admin-password $5 \
    --public-ip-sku Standard

    echo Windows VM created.
# Windows vm images win2019datacenter
}

VmOpenPort() {
    echo Opening port $3 for VM $2 ..
    echo
    az vm open-port \
    --resource-group $1 \
    --name $2 \
    --port $3

    echo Port opened.

# Windows -- RDP : 3389
# Linux -- UDP: 22
}

VmGetIpAddresses() {
    echo Getting ip addresses for $2 ..
    echo
    az vm list-ip-addresses \
    --resource-group $1 \
    --name $2 \
    --output table
}

SshLogin () {
    echo Loging ..
    echo
    ssh $1
}

ACR_Create (){
    echo Creating new ACR ..
    echo
    az acr create \
    --name $1 \
    --resource-group $2 \
    --sku $3 "Standard"
}

ACR_GetLoginServer(){
    az acr show --name $1 --query $2 loginServer --output $3 tsv
}

ACR_GetRegistryId(){
    az acr show --name $1 --query $2 id --output $3 tsv
}

SP_Create(){
    az ad sp create-for-rbac \
    --name $1 --scopes $2 --role $3 \
    --query $4 password --output $5 tsv
}