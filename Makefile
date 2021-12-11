
# VARIABLES
## container
CONTAINER_NAME = bygui86/go-config-yaml
## global
export GO111MODULE = on


# CONFIG
.PHONY: help print-variables
.DEFAULT_GOAL = help


# ACTIONS

## internals

__check-container-tag :
	@[ "$(CONTAINER_TAG)" ] || ( echo "Missing container tag (CONTAINER_TAG), please define it and retry"; exit 1 )

## code

mod-tidy :		## Tidy go modules references
	go mod tidy

mod-down : mod-tidy		## Download go modules references
	go mod download

build : mod-down		## Build application
	go build

## cointaier

container-build : __check-container-tag		## Build container image
	docker build . -t $(CONTAINER_NAME):$(CONTAINER_TAG)

container-push : __check-container-tag		## Push container image to Container Registry
	docker push $(CONTAINER_NAME):$(CONTAINER_TAG)


## helpers

help :		## Help
	@echo ""
	@echo "*** \033[33mMakefile help\033[0m ***"
	@echo ""
	@echo "Targets list:"
	@grep -E '^[a-zA-Z_-]+ :.*?## .*$$' $(MAKEFILE_LIST) | sort -k 1,1 | awk 'BEGIN {FS = ":.*?## "}; {printf "\t\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

print-variables :		## Print variables values
	@echo ""
	@echo "*** \033[33mMakefile variables\033[0m ***"
	@echo ""
	@echo "- - - makefile - - -"
	@echo "MAKE: $(MAKE)"
	@echo "MAKEFILES: $(MAKEFILES)"
	@echo "MAKEFILE_LIST: $(MAKEFILE_LIST)"
	@echo "- - -"
	@echo "CONTAINER_NAME: $(CONTAINER_NAME)"
	@echo ""
