---
name: nvidia-setup
description: Use this skill when installing or repairing NVIDIA GPU drivers, CUDA,
  Fabric Manager, or Docker GPU runtime on Ubuntu Linux servers. Use it when the user
  asks to set up a GPU host, clean up an old NVIDIA stack, prepare a server for CUDA
  or vLLM workloads, or validate that containers can see GPUs.
metadata:
  oasr:
    hash: sha256:89e6689efd72e60b31ee7cba02120abd654b5b9fd93aa468d83601292e210fe2
    source: skills/nvidia-setup
    synced: 'generated'
---

# NVIDIA GPU Driver + CUDA Setup

Use this skill on bare-metal or VM Linux servers that actually own NVIDIA GPUs. It is written for Ubuntu systems that use `apt`.

Do not use this workflow for:

- WSL2 guest environments
- macOS or Windows hosts
- Debian, RHEL, Rocky, Fedora, or SUSE systems
- Containers that do not own the host GPU stack

Always announce the skill at the start:

```text
I'm using the nvidia-setup skill to configure the NVIDIA software stack.
```

## Workflow

Follow the steps in order. Prefer running the bundled scripts from the skill root:

```bash
cd /path/to/nvidia-setup/steps
./00-preflight.sh
./01-detect-gpu.sh
```

Continue step-by-step instead of jumping straight to installation.

## Step 0: Pre-flight Checks

**Script:** `steps/00-preflight.sh`

Run this first. It verifies:

- Linux is the host OS
- The machine is not WSL
- `apt-get` is available
- NVIDIA GPU hardware is present

## Step 1: Detect the Current State

**Script:** `steps/01-detect-gpu.sh`

Run detection before making any changes. Collect:

- GPU model names
- Current driver version
- CUDA compiler version
- Installed NVIDIA/CUDA packages
- OS release and kernel
- Whether `nvidia-smi topo -m` shows NVSwitch

State the detected GPU family explicitly before proceeding.

## Step 2: Research Current Driver Guidance

Before installing, verify current official guidance on the NVIDIA docs:

- `https://docs.nvidia.com/datacenter/tesla/index.html`
- `https://docs.nvidia.com/datacenter/tesla/driver-installation-guide/`
- `https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/`
- `https://docs.nvidia.com/cuda/cuda-installation-guide-linux/`
- `https://docs.nvidia.com/deploy/cuda-compatibility/forward-compatibility.html`

As of **July 7, 2026**, current NVIDIA guidance indicates:

- Linux Unix production branch: `595.84`
- Linux Unix new-feature branch: `610.43.03`
- CUDA Toolkit: `13.3 Update 1`
- CUDA 13.x minor-version compatibility: driver `580+`
- CUDA 13.3 toolkit-corresponding Linux driver: `610.43.02+`
- CUDA container tags include `nvidia/cuda:13.3.0-base-ubuntu24.04`

Practical default for this skill:

- Use `TARGET_DRIVER=595` for stable production installs unless the host/workload specifically needs CUDA 13.3 toolkit-corresponding driver `610+` or a newer new-feature branch.
- Use `TARGET_CUDA_PKG=13-3` for current CUDA 13.3 toolkit installs.
- For Ubuntu driver branches `590+`, install `nvidia-driver-pinning-<branch>` and then the unversioned driver package (`nvidia-open` or `cuda-drivers`). Do not use old package names such as `nvidia-open-595`.

Do not blindly install whatever is in this skill as a fixed truth. Reconfirm the driver branch against the detected GPU family and intended CUDA/tooling version.

## Step 3: Set Target Variables

After detection and research, state the chosen values before changing the system:

```bash
TARGET_DRIVER=595
TARGET_CUDA_PKG=13-3
USE_OPEN_MODULES=true
NVSWITCH_PRESENT=false
NEEDS_NVLSM=false
CUDA_TEST_IMAGE="nvidia/cuda:13.3.0-base-ubuntu24.04"
PYTORCH_IMAGE=""
```

Guidance:

- Use `TARGET_DRIVER=595` for production branch installs unless current docs or workload requirements justify a newer branch such as `610`.
- Use `TARGET_CUDA_PKG=13-3` when you want the current CUDA 13.3 package line.
- Set `USE_OPEN_MODULES=false` for Maxwell, Pascal, or Volta GPUs.
- Prefer `USE_OPEN_MODULES=true` for Turing and newer GPUs on modern releases.
- Set `NVSWITCH_PRESENT=true` only when topology output shows NVSwitch.
- Set `NEEDS_NVLSM=true` only for NVL systems that require it.
- Use `PYTORCH_IMAGE` only if you have a known-good CUDA-matched image to validate with.

Confirm the selections and the reasoning before proceeding.

## Step 4: Remove Old Packages

**Script:** `steps/04-remove-old.sh`

This purges existing NVIDIA and CUDA packages and removes old repository entries.

Run it when:

- the machine already has a partial or broken NVIDIA stack
- you are switching branches cleanly
- package dependency state is messy

## Step 5: Install Driver + CUDA

**Script:** `steps/05-install-driver.sh`

Supported environment variables:

- `TARGET_DRIVER=595`
- `TARGET_CUDA_PKG=13-3`
- `USE_OPEN_MODULES=true`

What it does:

- adds the NVIDIA CUDA repository keyring
- installs the selected driver branch
- installs the selected CUDA toolkit package

The script intentionally stops after install and tells you to reboot.

## Step 6: Install NVSwitch Services

**Script:** `steps/06-nvswitch.sh`

Supported environment variables:

- `TARGET_DRIVER=595`
- `NVSWITCH_PRESENT=false`
- `NEEDS_NVLSM=false`

This step installs and enables:

- `nvidia-fabricmanager-<driver>`
- `nvlsm` when explicitly required

Skip it when the system is not an NVSwitch platform.

## Step 7: Configure Docker GPU Runtime

**Script:** `steps/07-docker.sh`

This installs `nvidia-container-toolkit`, configures Docker, and restarts the daemon.

Run it only after the host driver is healthy.

## Step 8: Validate

**Script:** `steps/08-validate.sh`

Supported environment variables:

- `CUDA_TEST_IMAGE="nvidia/cuda:13.3.0-base-ubuntu24.04"`
- `PYTORCH_IMAGE=""`

Validation sequence:

1. Check the host with `nvidia-smi`
2. Check `nvcc --version`
3. Check Fabric Manager and related services
4. Check Docker runtime visibility
5. Run a containerized GPU smoke test
6. Optionally run a PyTorch image if one is provided

## Quick Reference

| GPU family | Examples | Driver branch guidance | Kernel module guidance |
| --- | --- | --- | --- |
| Maxwell / Pascal / Volta | P100, V100 | Reconfirm support before upgrade | Proprietary only |
| Turing | T4 | Reconfirm current docs | Open preferred |
| Ampere | A100, A30, A10 | 595 production branch is the default; 610 only when required | Open preferred |
| Ada | L4, L40, L40S | 595 production branch is the default; 610 only when required | Open preferred |
| Hopper | H100, H200 | 595 production branch is the default; 610 only when required | Open preferred |
| Blackwell | B200, B300, RTX PRO 6000 SE | Reconfirm latest branch and OS support; 610 may be required for CUDA 13.3 toolkit-corresponding driver | Open preferred |

## Notes

- Fabric Manager version should match the installed driver branch.
- CUDA 13.x applications require driver `580+` for minor-version compatibility, but CUDA 13.3's toolkit-corresponding Linux driver is `610.43.02+`.
- WSL uses the Windows host driver and should not install the Linux driver stack inside the guest.
- If you are installing for vLLM or PyTorch, choose the validation image after confirming its CUDA tag still matches the selected host stack.

## References

Read `references/compatibility.md` when you need the current branch, CUDA, and module selection notes while working through the install.
