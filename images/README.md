# EESSI host images

- Based on RHEL8
- Adds a few packages
- Uses arm64 as the image architecture for aarch64

# To build?

```
packer build default.ami.pkr.hcl
```

By default this builds the images in `eu-west-1`. To change this:

```
packer build -var="region=eu-central-1" default.ami.pkr.hcl
```

Or similar.
