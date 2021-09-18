# EESSI host images

- Based on RHEL8
- Adds a few packages
- Uses arm64 as the image architecture for aarch64

# To build?

Set the environment variable EESSI_SSH_KEYS to include all the keys that the EESSI account should have access to, on the form:

```
EESI_SSH_KEYS="ssh-rsa terjekv-key terjekv
ssh-rsa bob-key bob
ssh-ed25519 ash-key ashurbanipal"
```

```
packer build default.ami.pkr.hcl
```

By default this builds the images in `eu-west-1`. To change this:

```
packer build -var="region=eu-central-1" default.ami.pkr.hcl
```

Or similar.
