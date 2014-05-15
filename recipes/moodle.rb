#
# Cookbook Name:: moodle
# Recipe:: default
#
# Copyright 2012, Cogini
#

include_recipe 'apache2'
include_recipe 'git'
include_recipe 'php::module_apc'
include_recipe 'php::module_gd'
include_recipe 'php::module_mysql'
include_recipe 'database::mysql'


site_dir = node.default['moodle']['site_dir']
data_dir = node.default['moodle']['data_dir']
moodle_user = node.default['moodle']['user']
moodle_group = node.default['moodle']['group']

[site_dir, data_dir].each do |dir|
    directory dir do
        action :create
        recursive true
        user moodle_user
        group moodle_group
    end
end

ark 'moodle' do
    path '/var/www'
    url 'http://mirror.bit.edu.cn/moodle/stable25/moodle-latest-25.tgz'
    action :put
end

git "#{site_dir}/mod/programming" do
  repository "https://github.com/liling/moodle-mod-programming.git"
  reference "master"
  action :sync
end

# create a mysql database
mysql_database 'moodle' do
  connection ({:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

if !::File.exist?("#{site_dir}/config.php")
  execute "Install Moodle" do
    cwd "#{site_dir}/admin/cli"
    command "php install.php --lang=zh_cn --wwwroot='http://localhost/' --dataroot=#{data_dir} --shortname=oj --fullname=OJ --adminpass=moodle --non-interactive --agree-license"
  end

  execute "Change owner of #{data_dir}" do
    command "chown -R #{moodle_user}:#{moodle_group} #{data_dir}"
  end

  execute "Change perimssion of #{site_dir}/config.php" do
    command "chmod o+r #{site_dir}/config.php"
  end
end

apache_site "default" do
  enable true
end

cron 'moodle maintenance cron' do
  minute 5
  user node[:moodle][:moodle_user]
  command "php #{site_dir}/admin/cli/cron.php"
end
