user = 'vagrant'
home_dir = "/home/#{user}"

template "#{home_dir}/.bashrc" do
  source ".bashrc.erb"
  mode 0644
  owner user
  group user
end

template '/etc/mysql_grants.sql' do
  source 'etc/mysql_grants.sql.erb'
  owner  'root'
  group  'root'
  mode   '0600'
  notifies :run, 'execute[install-grants]', :immediately
end

execute 'install-grants' do
  command "/usr/bin/mysql -u root -p#{node['keys']['mysql']['root']} < /etc/mysql_grants.sql"
  action :nothing
  retry_delay 5
  retries 3
end

template '/etc/mysql/debian.cnf' do
  source 'etc/mysql/debian.cnf.erb'
  owner 'root'
  group 'root'
  mode '0600'
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

# Remove the default PHP FPM file.
file "/etc/php5/fpm/pool.d/www.conf" do
  action :delete
end

service "apache2" do
  action [:stop, :disable]
end

service 'mysql' do
  supports     :status => true, :restart => true, :reload => true
  action       [:enable, :start]
end

service "php5-fpm" do
  supports     :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

service "nginx" do
  supports     :status => true, :restart => true, :reload => true
  action [:enable, :restart]
end

Chef::Log.info("HOSTNAME: #{(%x{hostname -I}).split(' ').last}")
