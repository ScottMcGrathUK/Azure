
clear
$worksheetOwners = "Owners"
$owners = Import-Excel -Path $excelFile -WorksheetName $worksheetOwners


foreach ($owner in $owners) {
    $group = Get-AzADGroup -DisplayName $owner."Group Name"
    $approvers = $owner.Approver -split ";"
    $owners = $owner.Owner -split ";"
    $description = $owner.Description

    Set-AzADGroup -ObjectId $group.ObjectId -Description $description
    foreach ($approver in $approvers) {
        Add-AzADGroupOwner -ObjectId $group.ObjectId -OwnerObjectId (Get-AzADUser -UserPrincipalName $approver).ObjectId
    }
    foreach ($owner in $owners) {
        Add-AzADGroupOwner -ObjectId $group.ObjectId -OwnerObjectId (Get-AzADUser -UserPrincipalName $owner).ObjectId
    }
}

