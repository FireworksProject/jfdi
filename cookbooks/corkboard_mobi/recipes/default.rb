template "/etc/nginx/sites-enabled/corkboard_mobi" do
  source "etc/nginx/sites-available/corkboard_mobi.erb"
  mode 0644
  owner 'root'
  group 'root'
end

directory "/var/log/corkboard_mobi" do
  owner 'vagrant'
  group 'vagrant'
  mode 0744
  action :create
end

service "nginx" do
  action :restart
end
