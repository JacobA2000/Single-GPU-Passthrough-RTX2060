#!/bin/bash
set -x
 
# load variables
source "/etc/libvirt/hooks/kvm.conf"
 
 
# Stop display manager
systemctl stop sddm.service
# rc-service xdm stop
 
# Unbind EFI Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
 
sleep 5
 
# Unload NVIDIA kernel modules
modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia
 
 # unload psmouse
modprobe -r psmouse
# load psmouse with proto imps
modprobe psmouse proto=imps
 
# Detach GPU devices from host
# Use your GPU and HDMI Audio PCI host device
# unbind gpu
virsh nodedev-detach pci_0000_01_00_0
virsh nodedev-detach pci_0000_01_00_1
virsh nodedev-detach pci_0000_01_00_2
virsh nodedev-detach pci_0000_01_00_3
 
# Load vfio module
modprobe vfio-pci