#!/bin/bash
set -e

repos='armv7hf rpi i386 amd64'
nodeVersions='0.10.40 0.12.7 4.0.0 4.2.4 5.3.0'
resinUrl="http://resin-packages.s3.amazonaws.com/node/v\$NODE_VERSION/node-v\$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz"
nodejsUrl="http://nodejs.org/dist/v\$NODE_VERSION/node-v\$NODE_VERSION-linux-#{TARGET_ARCH}.tar.gz"

for repo in $repos; do
	case "$repo" in
	'rpi')
		binary_url=$resinUrl
		target_arch='armv6hf'
		baseImage='rpi-raspbian'
	;;
	'armv7hf')
		binary_url=$resinUrl
		target_arch='armv7hf'
		baseImage='armv7hf-debian'
	;;
	'i386')
		binary_url=$nodejsUrl
		target_arch='x86'
		baseImage='i386-debian'
	;;
	'amd64')
		binary_url=$nodejsUrl
		target_arch='x64'
		baseImage='amd64-debian'
	;;
	esac
	for nodeVersion in $nodeVersions; do
		echo $nodeVersion
		baseVersion=$(expr match "$nodeVersion" '\([0-9]*\.[0-9]*\)')
		dockerfilePath=$repo/$baseVersion

		mkdir -p $dockerfilePath/slim
			sed -e s~#{FROM}~resin/$baseImage:jessie~g \
				-e s~#{BINARY_URL}~$binary_url~g \
				-e s~#{NODE_VERSION}~$nodeVersion~g \
				-e s~#{TARGET_ARCH}~$target_arch~g Dockerfile.slim.tpl > $dockerfilePath/slim/Dockerfile
	done
done
