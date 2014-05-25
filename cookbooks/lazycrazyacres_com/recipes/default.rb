directory "/webapps/lazycrazyacres_com" do
  mode 0755
  owner 'vagrant'
  group 'vagrant'
  action :create
end

template "/etc/nginx/sites-enabled/lazycrazyacres_com" do
  source "etc/nginx/sites-available/lazycrazyacres_com.erb"
  mode 0644
  owner 'root'
  group 'root'
end

template "/etc/php5/fpm/pool.d/lazycrazyacres_com.conf" do
  source "etc/php5/fpm/pool.d/lazycrazyacres_com.conf.erb"
  mode 0644
  owner 'root'
  group 'root'
end

template '/etc/lazycrazyacres_mysql_grants.sql' do
  source 'etc/lazycrazyacres_mysql_grants.sql.erb'
  owner  'root'
  group  'root'
  mode   '0600'
  notifies :run, 'execute[install-lazycrazyacres-grants]', :immediately
end

execute 'install-lazycrazyacres-grants' do
  command "/usr/bin/mysql -u root -p#{node['keys']['mysql']['root']} < /etc/lazycrazyacres_mysql_grants.sql"
  action :nothing
  retry_delay 5
  retries 3
end

template "/webapps/lazycrazyacres_com/wp-config.php" do
  source "wp-config.php.erb"
  mode 0644
  owner 'vagrant'
  group 'vagrant'
end

service "php5-fpm" do
  action :restart
end

service "nginx" do
  action :restart
end
