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

service "php5-fpm" do
  action :restart
end

service "nginx" do
  action :restart
end
