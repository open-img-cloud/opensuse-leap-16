# openSUSE Leap 16 cloud images

Cloud-init-ready, signed openSUSE Leap 16 qcow2 images for OpenStack and Proxmox,
part of the [openimages.cloud](https://openimages.cloud) catalog.

- Catalog page: <https://openimages.cloud/images/opensuse-leap-16/>
- Registry: <https://images.openimages.cloud/opensuse-leap-16/latest/>

## About

openSUSE Leap 16 is the community distribution built from SUSE Linux Enterprise 16, published by the openSUSE Project
([https://www.opensuse.org/](https://www.opensuse.org/)). This repo takes the official upstream
Minimal-VM Cloud image ([listing](https://download.opensuse.org/distribution/leap/16.0/appliances/)), verifies it against the
upstream SHA-256 checksum, applies the openimages.cloud cloud-init policy,
boot-tests it, signs it with cosign (keyless) and publishes it.

The build pipeline is shared with the rest of
[`open-img-cloud`](https://github.com/open-img-cloud): this repo only ships
`VERSION`, `build/customize.sh`, `build/detect-upstream.sh` and two thin
caller workflows that delegate to the reusable workflows in
[`open-img-cloud/.github`](https://github.com/open-img-cloud/.github).

## Lifecycle

openSUSE Leap 16.0 is maintained until six months after the release of Leap 16.1. Upstream replaces the image in place (one build at a time), so the watcher follows the current build.

## Image

- File: `opensuse-leap-<version>-x86_64.qcow2`, where `<version>` is
  `16.0-<upstream build>` (e.g. `16.0-18.92`).
- Default user: `sles` (SSH key from cloud-init, passwordless sudo).
- The root filesystem grows to the flavor disk on first boot.

## Use it

```sh
V=16.0-18.92
curl -fLO https://images.openimages.cloud/opensuse-leap-16/$V/opensuse-leap-$V-x86_64.qcow2

openstack image create \
    --disk-format qcow2 --container-format bare \
    --property hw_qemu_guest_agent=yes \
    --file opensuse-leap-$V-x86_64.qcow2 \
    'openSUSE Leap 16 '$V
```

Verification (cosign), Proxmox commands and provenance details are on the
[catalog page](https://openimages.cloud/images/opensuse-leap-16/) and in the
[verification guide](https://openimages.cloud/verify/).

## Release flow

1. `watch.yml` runs daily (07:11 UTC) and opens an
   `auto/upstream-bump` pull request when upstream publishes a new image.
2. Merge it, then push the tag `v<VERSION>`: `release.yml` builds, boot-tests,
   signs and publishes the image.

## License

The build tooling in this repository is [GPL-2.0](LICENSE). The image keeps
the licensing terms of openSUSE. openSUSE is a trademark of SUSE LLC. This project is not affiliated with it.
