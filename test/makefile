.PHONY: buildImages bashNewNode unitTest
all: buildImages unitTest

SHELL:=/bin/bash
domain = master.saltstack.com
currentDirectory= $(shell pwd)
dockerTTYArgs= --rm -it --name $(domain)
addTests= -v $(currentDirectory):/test
addTools= -v $(currentDirectory)/../tools:/tools
addBootstrap= -v $(currentDirectory)/../bootstrap-node.sh:/bootstrap-node.sh

buildImages:
	@echo "Building SaltStack Docker Instances"
	docker build -t saltstack-bootstrap-new-node . -f Dockerfile.new_node

bashNewNode:
	@docker run $(dockerTTYArgs) $(addTests) $(addTools) $(addBootstrap) saltstack-bootstrap-new-node /bin/bash -c \
	"echo 'Opening Empty Node Environment'; \
	/bin/bash"

unitTest:
	@docker run $(dockerTTYArgs) $(addTests) $(addTools) $(addBootstrap) saltstack-bootstrap-new-node /bin/bash -c \
	"bash test/run-all-unit.sh"
