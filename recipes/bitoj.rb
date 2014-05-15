package "quota" do
  action :install
end

mount "/" do
  device "cloudimg-rootfs"
  device_type :label
  fstype "ext4"
  action :enable
  options "usrquota"
end

package "build-essential" do
  action :install
end

package "openjdk-7-jdk" do
  action :install
end

package "fpc" do
  action :install
end

package "mono-devel" do
  action :install
end

package "scilab" do
  action :install
end

remote_file "#{Chef::Config[:file_cache_path]}/bitoj_1.2-2_all.deb" do
  source "https://bitoj.googlecode.com/files/bitoj_1.2-2_all.deb"
end

dpkg_package "#{Chef::Config[:file_cache_path]}/bitoj_1.2-2_all.deb" do
  action :install
end
