# debug 
set -x

# Rebind GPU
virsh nodedev-reattach pci_0000_01_00_0
virsh nodedev-reattach pci_0000_01_00_1
virsh nodedev-reattach pci_0000_01_00_2
virsh nodedev-reattach pci_0000_01_00_3

# unload vfio
modprobe -r vfio
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1

# load nvidia
modprobe nvidia
modprobe nvidia_modeset
modprobe nvidia_drm
modprobe drm_kms_helper
modprobe drm
modprobe i2c_nvidia_gpu

# rebind vt
echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind

# read xconfig
nvidia-xconfig --query-gpu-info > /dev/null 2>&1

# bind efi buffer
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

# unload psmouse
modprobe -r psmouse
modprobe psmouse

# restart dm
systemctl start sddm.service
