SHELL := /usr/bin/env bash

# HOW TO EXECUTE
# Executing Terraform PLAN
#	$ make tf-plan env=<env>
# Executing Terraform APPLY
#   $ make tf-apply env=<env>
# Executing Terraform DESTROY
#	$ make tf-destroy env=<env>
#
# To unlock the state you should check the DDB item, retrieve the Lock ID, and run the following
# terraform force-unlock -force <lock_id_number>
#
# If you want to export the plan to a file to bettter understand, run the following
# terraform plan -var-file="./config/${env}/terraform-${env}.tfvars" -no-color  > tfplan-${env}.txt


all-test: clean tf-plan

.PHONY: clean
clean:
	rm -rf .terraform
.PHONY: init
init:
	terraform fmt && \
	terraform init -backend-config="./config/${env}/backend-${env}.conf"
.PHONY: upgrade
upgrade:
	terraform fmt && \
	terraform init -backend-config="./config/${env}/backend-${env}.conf" -upgrade
.PHONY: format
fmt:
	@terraform fmt --recursive
.PHONY: validate
validate:
	@terraform validate
.PHONY: plan
plan:
	@terraform plan -var-file "./config/${env}/terraform-${env}.tfvars"
.PHONY: summary
summary:
	@terraform plan -var-file "./config/${env}/terraform-${env}.tfvars" -out "plans/${env}/tfplan-${env}"
	@tf-summarize "plans/${env}/tfplan-${env}"
.PHONY: apply
apply:
	@terraform apply -var-file "./config/${env}/terraform-${env}.tfvars"
.PHONY: destroy
destroy:
	@terraform destroy -var-file "./config/${env}/terraform-${env}.tfvars"
.PHONY: launch
launch:
	@clear
	@make fmt env=${env}
	@make validate env=${env}
	@make apply env=${env}
