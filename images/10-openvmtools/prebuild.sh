#!/bin/bash
set -e

cd $(dirname $0)

rm -rf ./open-vm-tools

wget https://github.com/alpinelinux/aports/archive/v3.11.2.tar.gz \
	&& tar xvzf v3.11.2.tar.gz \
	&& cp -r aports-3.11.2/community/open-vm-tools . \
	&& rm -rf aports-3.11.2 v3.11.2.tar.gz
