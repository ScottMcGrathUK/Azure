# ARM Templates

ARM Templates are simply declarative 

## Handy VSCode Extensions

You can write ARM Templates in pretty much any text editor but I find VSCode to be the best.

There are a couple of handy extensions that help you with writing and managing ARM templates. These can be installed from directly within VSCode but these are the links for you to find them.

[Azure Resource Manager (ARM) Tools](https://marketplace.visualstudio.com/items?itemName=msazurermtools.azurerm-vscode-tools)

[ARM Template Viewer](https://marketplace.visualstudio.com/items?itemName=bencoleman.armview)

Key components of an Arm Template

| **Element**    | **Description**                                                                                                                                                                                                              |
|----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| schema         | A required section that defines the location of the JSON schema file that describes the structure of JSON data. The version number you use depends on the scope of the deployment and your JSON editor.                      |
| contentVersion | A required section that defines the version of your template (such as 1.0.0.0). You can use this value to document significant changes in your template to ensure you're deploying the right template.                       |
| apiProfile     | An optional section that defines a collection of API versions for resource types. You can use this value to avoid having to specify API versions for each resource in the template.                                          |
| parameters     | An optional section where you define values that are provided during deployment. These values can be provided by a parameter file, by command-line parameters, or in the Azure portal.                                       |
| variables      | An optional section where you define values that are used to simplify template language expressions.                                                                                                                         |
| functions      | An optional section where you can define user-defined functions that are available within the template. User-defined functions can simplify your template when complicated expressions are used repeatedly in your template. |
| resources      | A required section that defines the actual items you want to deploy or update in a resource group or a subscription.                                                                                                         |
| output         | An optional section where you specify the values that will be returned at the end of the deployment.                                                                                                                         |
