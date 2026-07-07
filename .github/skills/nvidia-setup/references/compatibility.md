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

Checked against NVIDIA documentation on **April 22, 2026**:

- Latest published data center branch in the index: `R595`
- Current published R595 Linux version: `595.58.03`
- Prior major branch still listed in the index: `R590`
- Current published R590 Linux version: `590.48.01`

Implication:

- If the workload targets CUDA 13.2, start by validating `R595`.
- If the environment is pinned to CUDA 13.1, `R590` may still satisfy compatibility, but verify OS and GPU support before using it.

## CUDA compatibility guidance

NVIDIA's forward compatibility guidance currently indicates:

- CUDA 13.0 requires `580+`
- CUDA 13.1 requires `590+`
- CUDA 13.2 requires `595+`

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

For pinned installs, distro repositories commonly expose versioned packages such as:

- `cuda-toolkit-13-2`
- `cuda-toolkit-13-1`
- `cuda-toolkit-13-0`

The bundled install script accepts `TARGET_CUDA_PKG` so you can pin the exact package line you researched.

## NVSwitch and services

Use Fabric Manager only when the platform actually needs it. Common cases:

- PCIe-only single-GPU or multi-GPU hosts: usually no Fabric Manager
- HGX / NVSwitch systems: Fabric Manager is typically required
- NVL systems that explicitly require NVLSM: install `nvlsm` in addition to Fabric Manager

Match Fabric Manager to the selected driver branch:

- `nvidia-fabricmanager-595` with driver `595`
- `nvidia-fabricmanager-590` with driver `590`

## Validation image guidance

The skill defaults to a lightweight CUDA image:

```bash
CUDA_TEST_IMAGE="nvidia/cuda:13.2.1-base-ubuntu22.04"
```

If you want a framework-level validation, set `PYTORCH_IMAGE` to a current image that matches the host CUDA stack before running the validation step.
