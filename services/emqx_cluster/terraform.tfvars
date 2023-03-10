## common

region = "us-west1"
zone    = "us-west1-c"
project = "tf-demo-380106"
namespace = "emqx"

## vnet

emqx_address_space = "10.0.0.0/16"

## vm

emqx_instance_count = 3
emqx_instance_type          = "e2-medium"


## emqx package url

emqx_package = "https://www.emqx.com/en/downloads/enterprise/4.4.14/emqx-ee-4.4.14-otp24.3.4.2-1-ubuntu20.04-amd64.zip"

## service account credentials

credentials = "/Users/bxb/Downloads/tf-demo-380106-60a6f61ea686.json"
