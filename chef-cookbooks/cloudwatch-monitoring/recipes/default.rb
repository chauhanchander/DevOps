#
# Cookbook Name::       cloudwatch_monitoring
# Description::         Base configuration for cloudwatch_monitoring
# Recipe::              default
# Author::              Neill Turner
#
# Copyright 2013, Neill Turner
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#include_recipe 'apt'
#include_recipe 'zip'

%w{libwww-perl libcrypt-ssleay-perl libswitch-perl ruby-mixlib-shellout}.each do |pkgs|
package "#{pkgs}" do
  action :install
  end
end

chef_gem 'mixlib-shellout'

remote_file "#{node[:cw_mon][:home_dir]}/CloudWatchMonitoringScripts-v#{node[:cw_mon][:version]}.zip" do
  source "#{node[:cw_mon][:release_url]}"
  owner "#{node[:cw_mon][:user]}"
  group "#{node[:cw_mon][:group]}"
  mode 0755 
  not_if { ::File.exists?("#{node[:cw_mon][:home_dir]}/CloudWatchMonitoringScripts-v#{node[:cw_mon][:version]}.zip")}
end

execute "unzip cloud watch monitoring scripts" do
  command "unzip #{node[:cw_mon][:home_dir]}/CloudWatchMonitoringScripts-v#{node[:cw_mon][:version]}.zip"
  cwd "#{node[:cw_mon][:home_dir]}"
  user "#{node[:cw_mon][:user]}"
  group "#{node[:cw_mon][:group]}"
  not_if { ::File.exists?("#{node[:cw_mon][:home_dir]}/aws-scripts-mon")}
end

bash "finding instance id" do
  code <<-EOF
    ec2metadata | grep instance-id: | cut -d' ' -f2 > /root/instance
  EOF
    not_if do ::File.exists?('/root/instance') end
end

execute "installing GEM mixlib-shellout" do
  command "gem install mixlib-shellout"
  not_if "gem list | grep mixlib-shellout"
end

#file "#{node[:cw_mon][:home_dir]}/CloudWatchMonitoringScripts-v#{node[:cw_mon][:version]}.zip" do
#  action :delete    
#  not_if { ::File.exists?("#{node[:cw_mon][:home_dir]}/CloudWatchMonitoringScripts-v#{node[:cw_mon][:version]}.zip")== false }
#end

remote_file "#{node[:cw_mon][:home_dir]}/CloudWatch-#{node[:cw_mon][:cw_version]}.zip" do
  source "#{node[:cw_mon][:cw_url]}"
  owner "#{node[:cw_mon][:user]}"
  group "#{node[:cw_mon][:group]}"
  mode 0755
  not_if { ::File.exists?("#{node[:cw_mon][:home_dir]}/CloudWatch-#{node[:cw_mon][:cw_version]}.zip")}
end

execute "unzip cloud watch cli scripts" do
  command "unzip #{node[:cw_mon][:home_dir]}/CloudWatch-#{node[:cw_mon][:cw_version]}.zip"
  cwd "#{node[:cw_mon][:home_dir]}"
  user "#{node[:cw_mon][:user]}"
  group "#{node[:cw_mon][:group]}"
  not_if { ::File.exists?("#{node[:cw_mon][:home_dir]}/CloudWatch-#{node[:cw_mon][:cw_version]}")}
end
   
bash "set cw home path" do
  code <<-EOF 
    echo "export AWS_CLOUDWATCH_HOME=/home/ubuntu/CloudWatch-#{node[:cw_mon][:cw_version]}" >> ~/.bashrc
    echo "export PATH=$PATH:/home/ubuntu/CloudWatch-#{node[:cw_mon][:cw_version]}/bin" >> ~/.bashrc
    source ~/.bashrc
  EOF
#    not_if 'cat ~/.bashrc | grep CloudWatch'
end
 
#bash "set JAVA home path in CloudWatch" do
#  code <<-EOH
#    sed  -i '4s/^/export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 /' /home/ubuntu/CloudWatch-1.0.20.0/bin/service
##  EOH
#  not_if 'cat /home/ubuntu/CloudWatch-1.0.20.0/bin/service | grep java-7-openjdk-amd64'
#end
 
template "/home/ubuntu/CloudWatch-1.0.20.0/bin/service" do
  source "service.erb"
  mode "0755"
end

template "/home/ubuntu/CloudWatch-1.0.20.0/bin/mon-put-metric-alarm" do
  source "mon-put-metric-alarm.erb"
  mode "0755"
end


template "#{node[:cw_mon][:home_dir]}/aws-scripts-mon/awscreds.conf" do
  owner "#{node[:cw_mon][:user]}"
  group "#{node[:cw_mon][:group]}"
  mode 0644
  source "awscreds.conf.erb"
  variables     :cw_mon => node[:cw_mon]
end

cron "cloudwatch_schedule_metrics" do
  action :create 
  minute "*/5"
  user "#{node[:cw_mon][:user]}"
  home "#{node[:cw_mon][:home_dir]}/aws-scripts-mon"
  command "#{node[:cw_mon][:home_dir]}/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --mem-avail --swap-util --swap-used --disk-path=/ --disk-space-used --disk-space-avail --disk-space-util --aws-credential-file #{node[:cw_mon][:home_dir]}/aws-scripts-mon/awscreds.conf --disk-path=/ --from-cron"
end

#require 'mixlib/shellout'
#instanceid = Mixlib::ShellOut.new("cat /root/instance 2>&1").run_command.stdout.strip

#bash "finding instance id" do
#  code <<-EOF
#    ec2metadata | grep instance-id: | cut -d' ' -f2 > /root/instance
#  EOF
#    not_if do ::File.exists?('/root/instance') end
#end 

#instanceid = Mixlib::ShellOut.new("cat /root/instance 2>&1").run_command.stdout.strip
instanceid = Mixlib::ShellOut.new("ec2metadata --instance-id").run_command.stdout.strip
template "/home/alarms.sh" do
  source "alarms.sh.erb"
  variables('instances' => instanceid,
            'alarm' => node[:cw_mon][:cw_alarm])
  mode "0755"
end

execute "Running Script to setup Alarms" do
   command "export AWS_CLOUDWATCH_HOME=/home/ubuntu/CloudWatch-1.0.20.0/ && sh /home/alarms.sh > /tmp/alarmfile 2>&1"
   not_if "cat /home/alarms | grep OK"
end
