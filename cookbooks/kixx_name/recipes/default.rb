template "/etc/nginx/sites-enabled/kixx_name" do
  source "etc/nginx/sites-available/kixx_name.erb"
  mode 0644
  owner 'root'
  group 'root'
end

service "nginx" do
  action :restart
end
