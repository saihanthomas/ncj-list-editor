# About
AppExchange にある [List Editor](https://appexchange.salesforce.com/appxListingDetail?listingId=a0N4V00000Fz2VxUAJ&tab=d)　 アプリのカスタマイズバージョンです。案件の要件によってカスタマイズしました。<br>
オリジナルソースコード > https://github.com/SalesforceLabs/ListEditor<br>


# How to deploy

## Pre requisites 
Visual studio code<br>
Already setup sfdx environment at vs code


## Deployment
open code folder at vs code <br>
check which org is being logged in at vs code > sfdx force:org:display <br>
authorize target org in vs code > Ctrl+Shift+p <br>
select SFDX:Authorize an org > select Production > press Enter  <br>
when the browser window open > log in with org credentials in which we want to deploy <br>
go back to vs code > folder > force-app/main/default <br>
right click on default folder and click on Deploy source to org <br>

## OR
Click on this button 

<a href="https://githubsfdeploy.herokuapp.com/app/githubdeploy/saihanthomas/ncj-list-editor?ref=main2">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>


# Readme from original creator

## 詳細な設定マニュアルはコチラ ↓
日本語  
[https://salesforce.quip.com/ysAYAmh31aTG](https://salesforce.quip.com/ysAYAmh31aTG)  
  
## Check here setup detail manuals
English  
[https://salesforce.quip.com/WPbbAiZrEx6r](https://salesforce.quip.com/WPbbAiZrEx6r)


# other

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
