#!/usr/bin/env bash

# This script will retrieve, unpack and upload specified channel / build to the AWS.
# It assumes that bunzip2 and aws cli are available and configured with the appropriate target region.

# The following are defaults, but can be overridden via environment variables
BUCKET=${BUCKET:-"ais-vm-images"}
BUILD=${BUILD:-"1520.8.0"}
CHANNEL=${CHANNEL:-"stable"}

OLDCWD=$(pwd)
rm -fr $BUILD
mkdir $BUILD
cd $BUILD
curl -LO https://$CHANNEL.release.core-os.net/amd64-usr/$BUILD/coreos_production_ami_image.bin.bz2
bunzip2 coreos_production_ami_image.bin.bz2

aws s3 cp coreos_production_ami_image.bin s3://ais-vm-images/coreos_${BUILD}_production_ami_image.bin


cat << EOF > snapshot.json 
{
  "Description": "CoreOS $CHANNEL - $BUILD",
  "Format": "raw",
  "UserBucket": {
    "S3Bucket": "${BUCKET}",
    "S3Key": "coreos_${BUILD}_production_ami_image.bin"
  }
}
EOF

aws ec2 import-snapshot --description "CoreOS $CHANNEL - $BUILD" --disk-container file://snapshot.json
cd $OLDCWD
rm -fr $BUILD
