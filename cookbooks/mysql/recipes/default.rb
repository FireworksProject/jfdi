bash "setup MySQL pre-install credentials" do
  code <<-EOH
  echo mysql-server mysql-server/root_password password #{node['keys']['mysql']['root']} | debconf-set-selection  s
  echo mysql-server mysql-server/root_password_again password #{node['keys']['mysql']['root']}  | debconf-set-selections
  EOH
end

package "mysql-server"
package "php5-mysql"
