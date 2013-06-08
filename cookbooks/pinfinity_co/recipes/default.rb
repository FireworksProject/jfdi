template "/etc/nginx/sites-enabled/pinfinity_co" do
  source "etc/nginx/sites-available/pinfinity_co.erb"
  mode 0644
  owner 'root'
  group 'root'
end

template "/etc/php5/fpm/pool.d/pinfinity_co.conf" do
  source "etc/php5/fpm/pool.d/pinfinity_co.conf.erb"
  mode 0644
  owner 'root'
  group 'root'
end

directory "/var/pinfinity_hub/gallery" do
  recursive true
  owner 'vagrant'
  group 'vagrant'
  mode 0744
  action :create
end

directory "/var/pinfinity_hub/data" do
  recursive true
  owner 'vagrant'
  group 'vagrant'
  mode 0744
  action :create
end

directory "/var/pinfinity_hub/downloads" do
  recursive true
  owner 'vagrant'
  group 'vagrant'
  mode 0744
  action :create
end

directory "/var/log/pinfinity_hub" do
  owner 'vagrant'
  group 'vagrant'
  mode 0744
  action :create
end

# FIXME: This cannot be done with sudo
# bash "start_pinfinity_hub" do
#  code <<-EOH
#  /webapps/pinfinity_hub/bin/restart
#  EOH
# end

service "php5-fpm" do
  action :restart
end

service "nginx" do
  action :restart
end
