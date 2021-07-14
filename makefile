# Make sure you are login using az cli
# az login 

ENV := $(env)
TF_CMD := terraform
TF_OUT := ../env/${ENV}/terraform-$(ENV).plan

fmt: 
	$(info $$env is [${env}])
	$(TF_CMD) fmt -recursive

clean:
	rm -rf infra/$(infra)/.terraform

init:
	cd infra/$(infra); \
	$(TF_CMD) init; \
	cd -
	
plan: init
	cd infra/$(infra); \
	$(TF_CMD) plan \
		-var-file="../env/$(ENV)/terraform.tfvars" \
		-out $(TF_OUT); \
	cd -


apply: plan
	cd infra/$(infra); \
	$(TF_CMD) apply $(TF_OUT); \
	cd -

destroy:
	cd infra/$(infra); \
	$(TF_CMD) destroy \
		-var-file="../env/$(ENV)/terraform.tfvars"; \
	cd -