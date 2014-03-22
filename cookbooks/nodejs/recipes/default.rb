package "python-software-properties"

bash "install-nodejs-repository" do
  code <<-EOH
  apt-add-repository -y ppa:chris-lea/node.js
  apt-get update
  EOH
end

package "nodejs"
