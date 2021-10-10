# debug
set -x

# stop dm
systemctl stop sddm.service

# unbind vt
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# unbind efi buffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# avoid race condition
sleep 5

# unload nvidia
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r drm_kms_helper
modprobe -r nvidia
modprobe -r i2c_nvidia_gpu
modprobe -r drm
# modprobe -r nvidia_uvm

# unload psmouse
modprobe -r psmouse

# load psmouse with proto imps
modprobe psmouse proto=imps

# unbind gpu
virsh nodedev-detach pci_0000_01_00_0
virsh nodedev-detach pci_0000_01_00_1
virsh nodedev-detach pci_0000_01_00_2
virsh nodedev-detach pci_0000_01_00_3

# load vfio
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1
