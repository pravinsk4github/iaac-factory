# Product: Infrastructure as a Code
# DOC: 14/07/2021
# Purpose: Code for providing infrastructure for the web application deployment
# Tool used: Terraform v/1.0.1
-----------------------------------------------------------------------------------------------------



    IaaC-Factory
    	|__ infra (entry point for the IAAC code) 
        	|--- provider.tf  (Azure) 
        	|--- backend.tf (will be used for configuring remote state) 
			|--- data.tf  (data-sources)
        	|--- main.tf (aggregator script that assembles different modules to build the desired environment)
			|--- security-rules.tf (security rules for subnet)
        	|--- variable.tf (input parameters for configuring infrastructure) 
			|--- web.conf (script for installing nginx on vms)
        	| 
    	|__ env (different evironmental settings)
        	|--- dev
        	|   |--- *.tfvars
        	|--- qa [Not added any files just left folder for example]
         	|  
			|__ modules
					|--- asg (application security group)		
					|		|--- main.tf
					|		|--- variables.tf
					|		|___ outputs.tf
					|
					|--- keyvault (used for storing vm passwrod, usually should us certificates instead)		
					|		|--- main.tf
					|		|--- variables.tf
					|		|___ outputs.tf
					|
					|--- storage-account (used for diagnostics & web app static image storage)		
					|		|--- main.tf
					|		|--- variables.tf
					|		|___ outputs.tf
					|
					|--- networking		
					|		|--- main.tf
					|		|--- variables.tf
					|		|___ outputs.tf
					|
					|--- nsg(network security group)		
					|		|--- main.tf
					|		|--- variables.tf
					|		|___ outputs.tf
					|
					|--- flowlog (not integrated)
					|		|--- main.tf
					|		|--- variables.tf
					|		|___ outputs.tf
					|
					|--- vmss (with load-balancer)
					|		|--- main.tf
					|		|--- variables.tf
					|		|___ outputs.tf
					|	
					|--- log_analytics (not integrated)
					|		|--- main.tf
					|		|--- variables
					|		|___ outputs.tf
		

Pending task -
Log analytics
Jumpbox integration
Testing using terratest
