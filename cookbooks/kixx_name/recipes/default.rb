template "/etc/nginx/sites-enabled/kixx_name" do
  source "etc/nginx/sites-available/kixx_name.erb"
  mode 0644
  owner 'root'
  group 'root'
end

directory "/var/log/kixx_name" do
  owner 'vagrant'
  group 'vagrant'
  mode 0744
  action :create
end

service "nginx" do
  action :restart
end
