param location string = resourceGroup().

@minLength(3)
@maxLength(24)
param stgActName string 

@allowed([
  'Standard_LRS'
  'Standard_GRS'
])
param stgActSku string = 'Standard_LRS'

param stgTags object = {
  Application: 'Secure File Copy'
}