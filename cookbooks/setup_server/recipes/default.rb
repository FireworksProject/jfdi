user = 'vagrant'
home_dir = "/home/#{user}"

template "#{home_dir}/.bashrc" do
  source ".bashrc.erb"
  mode 0644
  owner user
  group user
end

directory "/webapps" do
  mode 0755
  owner user
  group user
  action :create
end

template "/etc/nginx/nginx.conf" do
  source "etc/nginx/nginx.conf.erb"
  mode 0644
  owner 'root'
  group 'root'
end

# Remove the default sites-enabled file.
file "/etc/nginx/sites-enabled/default" do
  action :delete
end

template "/etc/nginx/sites-enabled/couchdb" do
  source "etc/nginx/sites-available/couchdb.erb"
  mode 0644
  owner 'root'
  group 'root'
end

couchdb_configs = {
  'admins' => node['couch_db']['config']['admins'],
  'couch_httpd_auth' => node['couch_db']['config']['couch_httpd_auth']
}
if node['keys']['couchdb']
  couchdb_configs['admins'] = node['keys']['couchdb']['admins']
end

template "/usr/local/etc/couchdb/local.d/admin-users.ini" do
  source "usr/local/etc/couchdb/local.d/admin-users.ini.erb"
  owner "couchdb"
  group "couchdb"
  mode 0660
  variables :config => couchdb_configs
end

service "apache2" do
  action [:stop, :disable]
end

service "couchdb" do
  action [:enable, :restart]
end

service "php5-fpm" do
  action [:enable, :start]
end

service "nginx" do
  action [:enable, :restart]
end

Chef::Log.info("HOSTNAME: #{(%x{hostname -I}).split(' ').last}")
