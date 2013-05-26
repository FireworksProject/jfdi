package "build-essential"
package "libssl-dev"

remote_file "#{Chef::Config[:file_cache_path]}/node-v0.10.8.tar.gz" do
  source "http://nodejs.org/dist/v0.10.8/node-v0.10.8.tar.gz"
  action :create_if_missing
end

bash "install-node" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  tar -xzf node-v0.10.8.tar.gz
  (cd node-v0.10.8 && ./configure && make && make install)
  EOH
  not_if "node --version 2>&1 | grep v0.10.8"
end
