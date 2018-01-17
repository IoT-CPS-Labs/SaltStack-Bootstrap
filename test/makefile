.PHONY: buildImages bashNewNode bashMaster unitTest integrationTest createNetwork deleteNetwork startMinion stopMinion
all: buildImages unitTest integrationTest

SHELL:=/bin/bash
domain= master.saltstack.com
network= salt_network
currentDirectory= $(shell pwd)
dockerTTYArgs= --rm -it --name $(domain)
addTests= -v $(currentDirectory):/test
addTools= -v $(currentDirectory)/../tools:/tools
addBootstrap= -v $(currentDirectory)/../bootstrap-node.sh:/bootstrap-node.sh

buildImages:
	@echo "Building SaltStack Docker Instances"
	docker build -t saltstack-bootstrap-new-node . -f Dockerfile.new_node
	docker build -t saltstack-bootstrap-master-node . -f Dockerfile.master_node
	docker build -t saltstack-bootstrap-minion-node . -f Dockerfile.minion_node

bashNewNode:
	@docker run $(dockerTTYArgs) $(addTests) $(addTools) $(addBootstrap) saltstack-bootstrap-new-node /bin/bash -c \
	"echo 'Opening New Node Environment'; \
	/bin/bash"

bashMaster:
	@docker run $(dockerTTYArgs) $(addTests) saltstack-bootstrap-master-node /bin/bash -c \
	"echo 'Opening Master Node Environment'; \
	/bin/bash"

unitTest:
	@docker run $(dockerTTYArgs) $(addTests) $(addTools) $(addBootstrap) saltstack-bootstrap-new-node /bin/bash -c \
	"bash test/run-all-unit.sh"

integrationTest:
	$(MAKE) -i createNetwork
	$(MAKE) -i stopMinion
	$(MAKE) -i startMinion
	@docker run $(dockerTTYArgs) --name $(domain) --net $(network) $(addTests) saltstack-bootstrap-master-node /bin/bash -c \
	"sh test/run-all-integration.sh"
	$(MAKE) stopMinion
	$(MAKE) deleteNetwork

createNetwork:
	@docker network create --driver bridge $(network)

deleteNetwork:
	@docker network rm $(network)

startMinion:
	@docker run -d --name saltstack-bootstrap-minion-node --net $(network) saltstack-bootstrap-minion-node /bin/bash -c \
	"salt-minion"

stopMinion:
	@docker stop saltstack-bootstrap-minion-node
	@docker rm saltstack-bootstrap-minion-node
