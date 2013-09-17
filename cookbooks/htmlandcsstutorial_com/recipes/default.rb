template "/etc/nginx/sites-enabled/htmlandcsstutorial_com" do
  source "etc/nginx/sites-available/htmlandcsstutorial_com.erb"
  mode 0644
  owner 'root'
  group 'root'
end

directory "/var/htmlandcsstutorial_com/data" do
  recursive true
  owner 'vagrant'
  group 'vagrant'
  mode 0744
  action :create
end

directory "/var/log/htmlandcsstutorial_com" do
  owner 'vagrant'
  group 'vagrant'
  mode 0744
  action :create
end

service "nginx" do
  action :restart
end
