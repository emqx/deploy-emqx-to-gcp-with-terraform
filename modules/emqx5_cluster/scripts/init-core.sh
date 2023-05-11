#!/usr/bin/env bash

BASE_DIR="/tmp"
LIC="/tmp/emqx/etc/emqx.lic"

# Install necessary dependencies
sudo apt-get -y update
sudo apt-get -y install zip

# system config
sudo sysctl -w fs.file-max=2097152
sudo sysctl -w fs.nr_open=2097152
echo 2097152 | sudo tee /proc/sys/fs/nr_open
sudo sh -c "ulimit -n 1048576"

echo 'fs.file-max = 1048576' | sudo tee -a /etc/sysctl.conf
echo 'DefaultLimitNOFILE=1048576' | sudo tee -a /etc/systemd/system.conf

sudo tee -a /etc/security/limits.conf << EOF
root      soft   nofile      1048576
root      hard   nofile      1048576
ubuntu    soft   nofile      1048576
ubuntu    hard   nofile      1048576
EOF

# tcp config
sudo sysctl -w net.core.somaxconn=32768
sudo sysctl -w net.ipv4.tcp_max_syn_backlog=16384
sudo sysctl -w net.core.netdev_max_backlog=16384

sudo sysctl -w net.ipv4.ip_local_port_range='1024 65535'

sudo sysctl -w net.core.rmem_default=262144
sudo sysctl -w net.core.wmem_default=262144
sudo sysctl -w net.core.rmem_max=16777216
sudo sysctl -w net.core.wmem_max=16777216
sudo sysctl -w net.core.optmem_max=16777216

sudo sysctl -w net.ipv4.tcp_rmem='1024 4096 16777216'
sudo sysctl -w net.ipv4.tcp_wmem='1024 4096 16777216'

sudo modprobe ip_conntrack
sudo sysctl -w net.nf_conntrack_max=1000000
sudo sysctl -w net.netfilter.nf_conntrack_max=1000000
sudo sysctl -w net.netfilter.nf_conntrack_tcp_timeout_time_wait=30
sudo sysctl -w net.ipv4.tcp_max_tw_buckets=1048576
sudo sysctl -w net.ipv4.tcp_fin_timeout=15

# export emqx variables
# sudo cat >> ~/.bashrc<<EOF
# export EMQX_NODE__PROCESS_LIMIT=2097152
# export EMQX_NODE__MAX_PORTS=1048576
# export EMQX_LISTENER__TCP__EXTERNAL__ACCEPTORS=64
# export EMQX_LISTENER__TCP__EXTERNAL__MAX_CONN_RATE=10000
# export EMQX_LISTENER__TCP__EXTERNAL__ACTIVE_N=100
# export EMQX_SYSMON__LARGE_HEAP=64MB
# export EMQX_NODE__NAME=emqx@${local_ip}
# EOF
# source ~/.bashrc

# install emqx
sudo mkdir -p $BASE_DIR/emqx
sudo tar -xzf /tmp/emqx.tar.gz -C $BASE_DIR/emqx
sudo chown -R ubuntu:ubuntu $BASE_DIR/emqx
sudo rm /tmp/emqx.tar.gz

sudo sed -i '/^ *node {/,/^ *} *$/c\node {\n  name = "emqx@${local_ip}"\n  cookie = "${cookie}"\n  data_dir = "data"\n  role  = core\n}' $BASE_DIR/emqx/etc/emqx.conf
sudo sed -i 's|keyfile = "etc/certs/key.pem"|keyfile = "etc/certs/emqx.key"|g' $BASE_DIR/emqx/etc/emqx.conf
sudo sed -i 's|certfile = "etc/certs/cert.pem"|certfile = "etc/certs/emqx.pem"|g' $BASE_DIR/emqx/etc/emqx.conf
sudo sed -i 's|cacertfile = "etc\/certs\/cacert.pem"|cacertfile = "etc/certs/emqx_ca.pem"|g' $BASE_DIR/emqx/etc/emqx.conf
sudo sed -i '/^ *cluster {/,/^ *} *$/c\cluster {\n  name = emqxcl\n  discovery_strategy = static\n  core_nodes = ${core_nodes}\n  static {\n    seeds = ${all_nodes}\n  }\n}' $BASE_DIR/emqx/etc/emqx.conf


# create license file
if [ -n "${emqx_lic}" ]; then
sudo cat > $LIC<<EOF
${emqx_lic}
EOF

# generate certificate files
#
echo "${emqx_ca}" | sudo tee $BASE_DIR/emqx/etc/certs/emqx_ca.pem
echo "${emqx_key}" | sudo tee $BASE_DIR/emqx/etc/certs/emqx.key
echo "${emqx_cert}" | sudo tee $BASE_DIR/emqx/etc/certs/emqx.pem
