#!/usr/bin/env bash
set -euo pipefail

VM_DIR="${VM_DIR:-$HOME/vm/ubuntu}"
IMAGE_URL="${IMAGE_URL:-https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-arm64.img}"
IMAGE_NAME="${IMAGE_NAME:-jammy-server-cloudimg-arm64.img}"
SEED_NAME="${SEED_NAME:-seed.img}"
SSH_PUBKEY="${SSH_PUBKEY:-$HOME/.ssh/id_ed25519.pub}"
USER_NAME="${USER_NAME:-ubuntu}"
SSH_PORT="${SSH_PORT:-2223}"
MEMORY_MB="${MEMORY_MB:-3072}"
CPU_CORES="${CPU_CORES:-4}"
ACCEL="${ACCEL:-hvf}"
QEMU_BIOS="${QEMU_BIOS:-}"
QEMU_EXTRA_ARGS="${QEMU_EXTRA_ARGS:-}"

mkdir -p "$VM_DIR"
cd "$VM_DIR"

if [ ! -f "$SSH_PUBKEY" ]; then
  echo "SSH public key not found: $SSH_PUBKEY" >&2
  echo "Set SSH_PUBKEY to a valid .pub file." >&2
  exit 1
fi

if [ ! -f "$IMAGE_NAME" ]; then
  echo "Downloading cloud image..."
  curl -LO "$IMAGE_URL"
fi

cat > user-data <<EOF
#cloud-config
users:
  - name: ${USER_NAME}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - $(cat "$SSH_PUBKEY")
ssh_pwauth: false
disable_root: true
EOF

if command -v cloud-localds >/dev/null 2>&1; then
  cloud-localds "$SEED_NAME" user-data
else
  echo "cloud-localds not found. Install with: nix shell nixpkgs#cloud-utils" >&2
  exit 1
fi

if [ "$ACCEL" = "hvf" ]; then
  ACCEL_ARGS=( -accel hvf -cpu host )
else
  ACCEL_ARGS=( -accel "$ACCEL" -cpu cortex-a72 )
fi

BIOS_ARGS=()
if [ -z "$QEMU_BIOS" ]; then
  QEMU_SHARE="$(dirname "$(command -v qemu-system-aarch64)")/../share/qemu"
  if [ -f "$QEMU_SHARE/edk2-aarch64-code.fd" ]; then
    QEMU_BIOS="$QEMU_SHARE/edk2-aarch64-code.fd"
  elif [ -f "$QEMU_SHARE/edk2-arm-code.fd" ]; then
    QEMU_BIOS="$QEMU_SHARE/edk2-arm-code.fd"
  fi
fi
if [ -n "$QEMU_BIOS" ]; then
  BIOS_ARGS=( -bios "$QEMU_BIOS" )
else
  echo "Warning: UEFI firmware not found. Set QEMU_BIOS to an edk2-*-code.fd path." >&2
fi

EXTRA_ARGS=()
if [ -n "$QEMU_EXTRA_ARGS" ]; then
  read -r -a EXTRA_ARGS <<<"$QEMU_EXTRA_ARGS"
fi

echo "Starting QEMU (SSH on localhost:${SSH_PORT})..."
echo "Boot log will appear below. Stop with Ctrl+C."
qemu-system-aarch64 \
  -machine virt,highmem=on \
  "${ACCEL_ARGS[@]}" -smp "$CPU_CORES" -m "$MEMORY_MB" \
  -nographic -serial mon:stdio \
  "${BIOS_ARGS[@]}" \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::${SSH_PORT}-:22 \
  -drive if=virtio,file="$IMAGE_NAME",format=qcow2 \
  -drive if=virtio,file="$SEED_NAME",format=raw \
  "${EXTRA_ARGS[@]}"
