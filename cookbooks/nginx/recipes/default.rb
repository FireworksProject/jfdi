package "python-software-properties"

bash "install-nginx-repository" do
  code <<-EOH
  apt-add-repository ppa:nginx/stable --yes
  apt-get update
  EOH
end

package "nginx"

template "/etc/nginx/sites-available/default" do
  source "sites-available-default.erb"
  mode 0440
  owner "root"
  group "root"
end
