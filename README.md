# SaltStack-Bootstrap [![Build Status](https://travis-ci.org/alanrossx2/SaltStack-Bootstrap.svg?branch=master)](https://travis-ci.org/alanrossx2/SaltStack-Bootstrap)

## Installation On Production Servers
### Step 0: Port Configuration
Ensure ports 4505 and 4506 on the master node is accessible from each minion node.

### Step 1: Install the Salt Master on the master node

Option 1: Install the Salt Master without a Salt Formula repository:
<pre>
curl https://raw.githubusercontent.com/alanrossx2/SaltStack-Bootstrap/master/bootstrap-node.sh -o /tmp/bootstrap-node.sh
sudo -i bash /tmp/bootstrap-node.sh -m -n (string: node_name)
</pre>

Option 2: Install the Salt Master with an open source Salt Formula repository:
<pre>
curl https://raw.githubusercontent.com/alanrossx2/SaltStack-Bootstrap/master/bootstrap-node.sh -o /tmp/bootstrap-node.sh
sudo -i bash /tmp/bootstrap-node -m -n (string: node_name) -r (string: repository_url)
</pre>

Option 3: Install the Salt Master with a private Salt Formula repository:
<pre>
curl https://raw.githubusercontent.com/alanrossx2/SaltStack-Bootstrap/master/bootstrap-node.sh -o /tmp/bootstrap-node.sh
sudo -i bash /tmp/bootstrap-node.sh -m -n (string: node_name) -r (string: repository_url) -d
</pre>

### Step 2: Install the Salt Minion on all minion nodes

Installing a Salt Minion:
<pre>
curl https://raw.githubusercontent.com/alanrossx2/SaltStack-Bootstrap/master/bootstrap-node.sh -o /tmp/bootstrap-node.sh
sudo -i bash /tmp/bootstrap-node -n (string: node_name) -i (string: master_ip_address)
</pre>

### Step 3: Add the Salt Keys

Add the keys to the master:
<pre> sudo salt-key -a '*' </pre>

### Step 4: Verify the connection by pinging all the minions

Verify that the master can ping it's minions:
<pre> sudo salt '*' test.ping </pre>

## Testing

The goal of testing in this case is to verify that the script does in fact install the correct components and that the basic functions (connectivity) are functional. Docker is used as a testing tool to quickly emulate machines that SaltStack will be installed too.

<br>To test the script, first ensure docker is installed. Instructions to install Docker can be found here:
<pre> https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#set-up-the-repository </pre>

Running the tests can be done with the following commands:
<pre>
cd test
sudo make
</pre>
