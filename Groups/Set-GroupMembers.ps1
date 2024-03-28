<#
.SYNOPSIS
    Openes an Excel spreadhseet and creates nested groups in Azure AD.
.DESCRIPTION
    Opens an Excel Spreadsheet and creates groups and nested groups based on columns in that sheet.
.NOTES
    File Name      : New-AZNestedGroups.ps1
    Author         : Scott McGrath
    Prerequisite   : Install-Module ImportExcel
.LINK

.EXAMPLE
    New-AZNestedGroups -SpreadsheetName "C:\Path\To\Spreadsheet.xlsx"
    
    This example demonstrates how to use the New-AZNestedGroups function to create nested groups in 
    Azure AD based on the specified Excel spreadsheet. The function reads the "Hierarchy" worksheet 
    from the spreadsheet and creates parent groups using the values in the "PGroup" column. Then, it 
    reads the "GroupName" column and adds each group as a member to its corresponding parent group.
#>

$worksheetMembers = "Members"
$members = Import-Excel -Path $excelFile -WorksheetName $worksheetMembers

# Add members to the respective groups
foreach ($member in $members) {
    $group = Get-AzADGroup -DisplayName $member.Group
    $editors = $member.Editors -split ";"

    foreach ($editor in $editors) {
        $user = Get-AzADUser -UserPrincipalName $editor
        $existingMember = Get-AzADGroupMember -GroupObjectId $group.ObjectId -ObjectId $user.ObjectId -ErrorAction SilentlyContinue

        if ($null -eq $existingMember) {
            Add-AzADGroupMember -MemberObjectId $user.ObjectId -TargetGroupObjectId $group.ObjectId
        }
        else {
            Write-Host "Member $editor already exists in group $group.DisplayName"
        }
    }
}