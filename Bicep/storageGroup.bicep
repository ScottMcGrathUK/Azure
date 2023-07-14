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

param location string = 'UKSouth'

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: stgActName
  location: location
  sku: {
    name: stgActSku
  }
  kind: 'StorageV2'
  tags: stgTags
  properties: {
    accessTier: 'Hot'
  }
}
