# CoreOS import into AWS

The simplest happy path I've discovered for a working AMI within air-gapped AWS is as follows:

* Grab a AMI bin image for CoreOS. This can be imported into AWS via the VM Import functionality.

```
BUCKET=my-favorite-bucket BUILD=1520.8.0 CHANNEL=stable ./upload-ami.sh
```

* Once the snapshot has been created. From the AWS Console create an AMI based off the imported disk snapshot. This should use HVM NOT PV virtualization.
