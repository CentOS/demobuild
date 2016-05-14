
auth --enableshadow --passalgo=sha512

text
url --url="http://mirror.centos.org/centos/7/os/x86_64"
repo --name=updates --baseurl="http://mirror.centos.org/centos/7/updates/x86_64"
firstboot --disabled
keyboard --vckeymap=us --xlayouts='us'
lang en_US.UTF-8
selinux --permissive

network --device=eth0 --bootproto=static --ip=172.28.0.1 --netmask=255.255.0.0 --gateway=172.28.0.2 --nameserver=127.0.0.1,8.8.8.8 --activate --onboot=yes


rootpw centos
timezone America/Chicago --isUtc
user --groups=wheel --name=demouser --plaintext --password=centos

bootloader --location=mbr --append="console=ttyS0,115200 console=tty0 biosdevname=0 net.ifnames=0"
clearpart --all --initlabel
part /boot/efi --fstype=efi --grow --maxsize=200 --size=20
part /boot --fstype=ext4 --size=512
part pv.01 --fstype="lvmpv" --size=1 --grow
#
volgroup vg.01 --pesize=4096 pv.01
#
logvol / --fstype="xfs" --name=lv_root --size=1024 --vgname=vg.01 --grow --maxsize=5192

firewall --disabled

%packages
@core
@base
-aic94xx-firmware
-iwl6000g2a-firmware
-iwl2030-firmware
-iwl100-firmware
-iwl6000-firmware
-iwl2000-firmware
-libertas-sd8686-firmware
-ivtv-firmware
-libertas-usb8388-firmware
-iwl5000-firmware
-alsa-firmware
-iwl6000g2b-firmware
-iwl7260-firmware
-libertas-sd8787-firmware
-iwl6050-firmware
-iwl135-firmware
-iwl105-firmware
-iwl1000-firmware
-iwl5150-firmware
-iwl4965-firmware
-iwl3160-firmware
-iwl3945-firmware
-alsa-tools-firmware
-alsa-lib
-btrfs-progs
-abrt-addon-pstoreoops
-abrt-addon-ccpp
-abrt-libs
-abrt
-abrt-addon-python
-abrt-tui
-abrt-gui-libs
-abrt-gui
-abrt-python
-abrt-addon-vmcore
-abrt-dbus
-abrt-console-notification
-gnome-abrt
-abrt-addon-xorg
-abrt-addon-kerneloops
-abrt-cli
-abrt-desktop
-empathy
-libpurple
-telepathy-haze
-libpinyin-data
-ibus-libpinyin
-libpinyin
-gnome-boxes
-libvirt-client
-libvirt-daemon
-libvirt-daemon-driver-interface
-libvirt-daemon-driver-network
-libvirt-daemon-driver-nodedev
-libvirt-daemon-driver-nwfilter
-libvirt-daemon-driver-qemu
-libvirt-daemon-driver-secret
-libvirt-daemon-driver-storage
-libvirt-daemon-kvm
-libvirt-glib
-libvirt-gobject
-gnome-getting-started-docs
-gnome-initial-setup
-cjkuni-uming-fonts
-wqy-zenhei-fonts
-gnome-weather
-qemu-kvm
-subscription-manager
-subscription-manager-firstboot
-subscription-manager-gui
-orca
grub2-efi
bind-utils
bind
dhcp
tftp-server
git
isomd5sum
genisoimage
%end

%post

iotty=`tty`
exec > $iotty 2> $iotty 

yum -y install epel-release 
yum -y install "http://yum.theforeman.org/releases/1.11/el7/x86_64/foreman-release.rpm"
yum -y install "http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm"
yum -y install foreman-installer ansible 

echo 'foreman.democluster.osas' > /etc/hostname
cat << EOF > /etc/hosts
127.0.0.1       foreman.democluster.osas localhost localhost.localdomain localhost4 localhost4.localdomain4
::1             foreman.democluster.osas localhost localhost.localdomain localhost6 localhost6.localdomain6
EOF

echo 'foreman-installer -v --foreman-db-type postgresql --foreman-db-host=127.0.0.1 --foreman-proxy-tftp=true --foreman-proxy-tftp=true --foreman-proxy-tftp-servername=172.28.0.1 --foreman-proxy-dhcp=true --foreman-proxy-dhcp-interface=eth0 --foreman-proxy-dhcp-gateway=172.28.0.2 --foreman-proxy-dhcp-range="172.28.100.1 172.28.100.254" --foreman-proxy-dhcp-nameservers=172.28.0.1 --foreman-proxy-dns=true --foreman-proxy-dns-interface=eth0 --foreman-proxy-dns-zone=democluster.osas --foreman-proxy-dns-reverse=28.172.in-addr.arpa --foreman-proxy-dns-forwarders=4.2.2.1 --foreman-proxy-foreman-base-url=https://foreman.democluster.osas --foreman-admin-password=centos --enable-foreman-plugin-discovery --foreman-plugin-discovery-install-images=true && yum install tfm-rubygem-foreman_ansible' > /root/install-foreman.sh

rm -rf /etc/ansible
git clone https://github.com/CentOS/demobuild.git /etc/ansible

%end

shutdown
