## common

region    = "us-west1"
zone      = "us-west1-c"
project   = "cloud-native-385008"
namespace = "emqx"

## service account credentials

credentials = "/Users/bxb/Documents/EMQ/cloud-native-385008-d6d96b729d5a.json"


## vnet

emqx_address_space = "10.0.0.0/16"

## vm

emqx_instance_count = 3
emqx_instance_type  = "e2-medium"


## SSL/TLS

# enable_ssl_two_way = false
ca_common_name        = "RootCAa"
common_name           = "Server"
org                   = "EMQ"
validity_period_hours = 8760
early_renewal_hours   = 720

## Cookie for emqx
emqx_cookie = "emqx_secret_cookie"


## special to emqx 4
emqx4_package = "https://www.emqx.com/en/downloads/enterprise/4.4.16/emqx-ee-4.4.16-otp24.3.4.2-1-ubuntu20.04-amd64.zip"

## special to emqx 5
# is_emqx5         = true
# emqx5_core_count = 1
# emqx5_package    = "https://www.emqx.com/en/downloads/broker/5.0.24/emqx-5.0.24-ubuntu20.04-amd64.tar.gz"
