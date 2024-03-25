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


param (
    [Parameter(Mandatory = $true)]
    [string]$SpreadsheetName
)

function ExcelSheetCheck {
    param (
        [Parameter(Mandatory = $true)]
        [string]$SpreadsheetName
    )

    # Import the required module
    Import-Module ImportExcel

    # Define the expected sheet names and column names
    $expectedSheets = @("Hierarchy", "Owners", "Members")
    $expectedColumns = @{
        "Hierarchy" = @("ParentGroup", "Groups")
        "Owners" = @("GroupName", "Approver", "GroupOwner", "Description")
        "Members" = @("Member", "GroupName")
    }

    # Read the sheets from the Excel spreadsheet
    $sheets = Get-ExcelSheetInfo -Path $SpreadsheetName

    # Initialize error message
    $errorMessage = ""

    # Check if all expected sheets exist
    $missingSheets = $expectedSheets | Where-Object { $sheets.Name -notcontains $_ }
    if ($missingSheets) {
        $missingSheetsString = $missingSheets -join ", "
        $errorMessage += @"
Your Spreadsheet is not in the expected structure.
Expected sheets: $($expectedSheets -join ", ")
Missing sheets: $missingSheetsString
"@
    }

    # Check the columns in the Hierarchy sheet
    $hierarchySheet = $sheets | Where-Object { $_.Name -eq "Hierarchy" }
    $missingColumns = $expectedColumns["Hierarchy"] | Where-Object { $hierarchySheet.Columns.Name -notcontains $_ }
    if ($missingColumns) {
        $missingColumnsString = $missingColumns -join ", "
        $errorMessage += @"
Your Spreadsheet is not in the expected structure.
In the Hierarchy sheet, missing columns: $($missingColumns -join ", ")
"@
    }

    # Check the columns in the Owners sheet
    $ownersSheet = $sheets | Where-Object { $_.Name -eq "Owners" }
    $missingColumns = $expectedColumns["Owners"] | Where-Object { $ownersSheet.Columns.Name -notcontains $_ }
    if ($missingColumns) {
        $missingColumnsString = $missingColumns -join ", "
        $errorMessage += @"
Your Spreadsheet is not in the expected structure.
In the Owners sheet, missing columns: $($missingColumns -join ", ")
"@
    }

    # Check the columns in the Members sheet
    $membersSheet = $sheets | Where-Object { $_.Name -eq "Members" }
    $missingColumns = $expectedColumns["Members"] | Where-Object { $membersSheet.Columns.Name -notcontains $_ }
    if ($missingColumns) {
        $missingColumnsString = $missingColumns -join ", "
        $errorMessage += @"
Your Spreadsheet is not in the expected structure.
In the Members sheet, missing columns: $($missingColumns -join ", ")
"@
    }

    # Return error message if any checks failed
    if ($errorMessage) {
        $errorMessage
        return
    }
}

ExcelSheetCheck -SpreadsheetName $SpreadsheetName
# Import the required modules
Import-Module Az.Accounts
Import-Module Az.Resources

# Connect to Azure
#Connect-AzAccount

$worksheetHierarchy = "Hierarchy"
$parentGroups = Import-Excel -Path $SpreadsheetName -WorksheetName $worksheetHierarchy | Select-Object -ExpandProperty PGroup

# # Create the parent groups
# foreach ($group in $parentGroups) {
#     New-AzADGroup -DisplayName $group -MailNickname $group -SecurityEnabled $true
# }

# Start-Sleep -Seconds 120 # Wait for 2 minutes

# # Read the Hierarchy and GroupName columns from the Excel spreadsheet
# $groups = Import-Excel -Path $SpreadsheetName -WorksheetName $worksheetHierarchy | Select-Object -ExpandProperty GroupName

# foreach ($group in $groups) {
#     $parentGroup = Get-AzADGroup -DisplayName $group
#     $groupName = Import-Excel -Path $SpreadsheetName -WorksheetName $worksheetHierarchy |
#     Where-Object { $_.GroupName -eq $group } | Select-Object -ExpandProperty GroupName
    
#     Add-AzADGroupMember -MemberObjectId $groupName.ObjectId -TargetGroupObjectId $parentGroup.ObjectId
# }
