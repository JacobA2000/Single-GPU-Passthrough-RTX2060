#!/bin/bash
set -x
 
source "/etc/libvirt/hooks/kvm.conf"
 
# Unload vfio module
modprobe -r vfio-pci
 
# Attach GPU devices to host
# Use your GPU and HDMI Audio PCI host device
virsh nodedev-reattach pci_0000_01_00_0
virsh nodedev-reattach pci_0000_01_00_1
virsh nodedev-reattach pci_0000_01_00_2
virsh nodedev-reattach pci_0000_01_00_3
 
# Rebind framebuffer to host
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind
 
# Load NVIDIA kernel modules
modprobe nvidia_drm
modprobe nvidia_modeset
modprobe nvidia_uvm
modprobe nvidia

# unload psmouse
modprobe -r psmouse
# Reload psmouse
modprobe psmouse

# Restart Display Manager
systemctl start sddm.service