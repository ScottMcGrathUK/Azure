$templateFile = "azuredeploy.json"
$today = Get-Date -Format "MM-dd-yyyy"
$deploymentName = "addOutputs-" + "$today"
New-AzResourceGroupDeployment `
    -Name $deploymentName `
    -TemplateFile $templateFile `
    -storageName 'learnexercise12321' `
    -storageSKU Standard_GRS