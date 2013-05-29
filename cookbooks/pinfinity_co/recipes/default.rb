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
  owner 'vagrant'
  group 'vagrant'
  mode 0744
  action :create
end

service "php5-fpm" do
  action :restart
end

service "nginx" do
  action :restart
end
