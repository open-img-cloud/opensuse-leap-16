<p align="center">
  <a href="https://openimages.cloud/images/opensuse-leap-16/">
    <img src="https://openimages.cloud/img/og/opensuse-leap-16.png" alt="openSUSE Leap 16 cloud image for OpenStack and Proxmox" width="720">
  </a>
</p>

<p align="center">
  <a href="https://openimages.cloud/images/opensuse-leap-16/"><img alt="Latest version" src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fimages.openimages.cloud%2Fopensuse-leap-16%2Flatest%2FMANIFEST.json&query=%24.version&label=latest&color=2459c4&cacheSeconds=3600"></a>
  <a href="https://github.com/open-img-cloud/opensuse-leap-16/actions/workflows/release.yml"><img alt="Release" src="https://github.com/open-img-cloud/opensuse-leap-16/actions/workflows/release.yml/badge.svg"></a>
  <a href="https://openimages.cloud/verify/"><img alt="Signed with Sigstore cosign" src="https://img.shields.io/badge/signed-Sigstore%20cosign-2459c4"></a>
  <a href="https://openimages.cloud/quality/"><img alt="Boot-tested on OpenStack" src="https://img.shields.io/badge/boot--tested-OpenStack-2459c4"></a>
  <a href="LICENSE"><img alt="License GPL-2.0" src="https://img.shields.io/badge/license-GPL--2.0-555"></a>
</p>

<p align="center">
  <a href="https://openimages.cloud/images/opensuse-leap-16/"><b>Catalog page</b></a> ·
  <a href="https://images.openimages.cloud/opensuse-leap-16/latest/">Download</a> ·
  <a href="https://openimages.cloud/verify/">Verify</a> ·
  <a href="https://github.com/open-img-cloud/docs">Documentation</a> ·
  <a href="https://github.com/open-img-cloud/opensuse-leap-16/issues">Report an issue</a>
</p>

openSUSE Leap 16 cloud image (qcow2) for **OpenStack** and **Proxmox**: the official openSUSE
Minimal-VM Cloud appliance, verified, made ready for both clouds with the same rules as every
[openimages.cloud](https://openimages.cloud) image, signed with Sigstore cosign and boot-tested
on a real OpenStack before it is published.

## At a glance

| | |
|---|---|
| **Upstream** | [openSUSE](https://www.opensuse.org/) Leap 16.0 Minimal-VM Cloud appliance from [download.opensuse.org](https://download.opensuse.org/distribution/leap/16.0/appliances/), checked against its `.sha256` file |
| **Default user** | `sles`, SSH key only, passwordless `sudo` |
| **Firmware** | BIOS |
| **Format** | qcow2, x86_64, root filesystem grown to the disk at first boot |
| **Version** | `16.0-<upstream build>`, e.g. `16.0-18.92` ([all versions](https://images.openimages.cloud/opensuse-leap-16/versions.json)) |
| **Support** | Leap 16.0 is maintained until six months after the release of Leap 16.1 |

## Quick start

```sh
# Latest version and its file name, from the signed manifest
M=https://images.openimages.cloud/opensuse-leap-16/latest/MANIFEST.json
V=$(curl -fsS $M | jq -r .version); F=$(curl -fsS $M | jq -r .filename)
curl -fLO https://images.openimages.cloud/opensuse-leap-16/$V/$F
```

<details>
<summary><b>OpenStack</b></summary>

```sh
openstack image create --disk-format qcow2 --container-format bare \
  --property os_distro=opensuse --property os_version=16.0 \
  --property hw_qemu_guest_agent=yes --property os_admin_user=sles \
  --file "$F" "openSUSE Leap 16"
```

The full property set (SCSI disk, multiqueue, quiesced snapshots) is on the
[catalog page](https://openimages.cloud/images/opensuse-leap-16/) and in
[`index.json`](https://images.openimages.cloud/index.json). To keep images up to date
automatically, use [oic-sync](https://github.com/open-img-cloud/oic-sync).

</details>

<details>
<summary><b>Proxmox VE</b></summary>

The commands to create a cloud-init template from this image are on the
[catalog page](https://openimages.cloud/images/opensuse-leap-16/).

</details>

<details>
<summary><b>Verify the signature</b></summary>

```sh
curl -fLO https://images.openimages.cloud/opensuse-leap-16/$V/$F.bundle
cosign verify-blob "$F" --bundle "$F.bundle" \
  --certificate-identity-regexp '^https://github.com/open-img-cloud/\.github/\.github/workflows/build-(libguestfs|dib|nix-flake|freebsd)-image\.yml@' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

</details>

## What this image changes

On top of the official image, and nothing else:

- adds an SSH server drop-in that allows public keys only (no password, no keyboard-interactive
  prompt through PAM); `qemu-guest-agent` already ships in the upstream image;
- adds the openimages.cloud cloud-init policy: config drive read first, then the metadata
  service; no root login, no SSH password;
- cleans package caches and machine identity so every instance starts fresh.

Every release must pass the same [runtime contract](https://openimages.cloud/quality/) on
OpenStack: SSH with the injected key, cloud-init finished, DNS, hostname, root filesystem grown,
passwordless `sudo`, IPv6 address and egress.

## Notes

- The image ships the SUSE Linux Enterprise 16 cloud-init configuration, so the default user is
  `sles`, not `opensuse`.
- Upstream replaces the appliance in place, one build at a time: the watcher follows the current
  build.

## How releases happen

1. Every day at 07:11 UTC a watcher looks for a new upstream image and opens a pull request
   that bumps [`VERSION`](VERSION).
2. Merging it is all it takes: the release is tagged, built, signed, boot-tested and
   published, then `latest/` and the [catalog](https://openimages.cloud/images/) move to it.

This repository only holds what is specific to openSUSE Leap 16: [`VERSION`](VERSION),
[`build/customize.sh`](build/customize.sh), [`build/config/`](build/config), [`build/detect-upstream.sh`](build/detect-upstream.sh)
and thin workflows calling the shared pipeline in
[`open-img-cloud/.github`](https://github.com/open-img-cloud/.github).

## License

The build tooling in this repository is under [GPL-2.0](LICENSE). The image keeps the licensing
terms of openSUSE (free software under the license of each package). openSUSE is a trademark
of SUSE LLC; this project is not affiliated with SUSE or the openSUSE Project.
