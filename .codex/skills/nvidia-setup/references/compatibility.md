# NVIDIA Compatibility Notes

This reference captures the public guidance that informed the bundled workflow. Reconfirm on the official NVIDIA docs before changing a production host.

The bundled scripts in this repository target Ubuntu hosts, not generic Debian-family systems.

## Official docs to consult

- NVIDIA data center driver index:
  `https://docs.nvidia.com/datacenter/tesla/index.html`
- NVIDIA driver installation guide:
  `https://docs.nvidia.com/datacenter/tesla/driver-installation-guide/`
- CUDA forward compatibility:
  `https://docs.nvidia.com/deploy/cuda-compatibility/forward-compatibility.html`
- CUDA Linux installation guide:
  `https://docs.nvidia.com/cuda/cuda-installation-guide-linux/`

## Current branch snapshot

Checked against NVIDIA documentation on **July 7, 2026**:

- NVIDIA Unix driver archive lists Linux x86_64/aarch64 production branch `595.84`.
- NVIDIA Unix driver archive lists Linux x86_64/aarch64 new-feature branch `610.43.03`.
- NVIDIA data center driver index currently lists R580 data-center release notes, with older branches still present.
- CUDA Toolkit release notes for CUDA 13.3 Update 1 list `610.43.02` as the Linux driver version associated with the toolkit.

Implication:

- Start production Ubuntu installs at `TARGET_DRIVER=595` unless current docs or the workload require a newer new-feature branch.
- Use `TARGET_DRIVER=610` only when the host/workload specifically needs the CUDA 13.3 toolkit-corresponding driver or another feature unavailable in production branch 595.
- Do not infer that every CUDA 13.3 workload requires 610; CUDA 13.x minor-version compatibility allows 580+ drivers, but newer toolkit features can require newer drivers.

## CUDA compatibility guidance

NVIDIA's forward compatibility guidance currently indicates:

- CUDA 13.x minor-version compatibility requires `580+`
- CUDA 12.x minor-version compatibility requires `525+` and `<580`
- CUDA 11.x minor-version compatibility requires `450+` and `<525`

CUDA Toolkit 13.3 release notes list toolkit-corresponding Linux driver versions:

- CUDA 13.3 Update 1: `610.43.02+`
- CUDA 13.3 GA: `610.43.02+`
- CUDA 13.2 Update 1: `595.58.03+`
- CUDA 13.1 Update 1: `590.48.01+`
- CUDA 13.0 Update 2: `580.95.05+`

Do not select the CUDA package independently from the driver branch.

## Kernel module guidance

From the NVIDIA driver installation guide:

- Proprietary kernel modules are required for older Maxwell, Pascal, and Volta GPUs.
- Open kernel modules are supported on Turing and newer GPUs.
- Starting with the 560 driver series, open kernel modules are the default and suggested installation.

Practical rule for this skill:

- Maxwell / Pascal / Volta: use proprietary
- Turing and newer: prefer open unless the environment has a documented reason not to

## CUDA package guidance

The CUDA installation guide recommends the `cuda-toolkit` meta package for generic installs.

For pinned installs, distro repositories commonly expose versioned toolkit packages such as:

- `cuda-toolkit-13-3`
- `cuda-toolkit-13-2`
- `cuda-toolkit-13-1`
- `cuda-toolkit-13-0`

The bundled install script accepts `TARGET_CUDA_PKG` so you can pin the exact package line you researched. The default is `13-3`.

## Ubuntu driver package guidance

NVIDIA changed Ubuntu driver package naming for branch 590 and later:

- Install `nvidia-driver-pinning-<branch>` to lock a branch such as `595`.
- Then install the unversioned package:
  - `nvidia-open` for Turing and newer GPUs using open kernel modules.
  - `cuda-drivers` for proprietary modules or legacy GPU families.
- Do not use old branch-suffixed driver package names such as `nvidia-open-595` for branches `590+`.

For branches older than 590, the historical package names remain relevant:

- `nvidia-open-<branch>`
- `nvidia-driver-<branch>`

## NVSwitch and services

Use Fabric Manager only when the platform actually needs it. Common cases:

- PCIe-only single-GPU or multi-GPU hosts: usually no Fabric Manager
- HGX / NVSwitch systems: Fabric Manager is typically required
- NVL systems that explicitly require NVLSM: install `nvlsm` in addition to Fabric Manager

Match Fabric Manager to the selected driver branch:

- For `590+` Ubuntu packages, use unversioned `nvidia-fabricmanager` with the branch pinning package already installed.
- For older branches, use branch-suffixed packages such as `nvidia-fabricmanager-580`.

## Validation image guidance

The skill defaults to a lightweight CUDA image:

```bash
CUDA_TEST_IMAGE="nvidia/cuda:13.3.0-base-ubuntu24.04"
```

If you want a framework-level validation, set `PYTORCH_IMAGE` to a current image that matches the host CUDA stack before running the validation step.
