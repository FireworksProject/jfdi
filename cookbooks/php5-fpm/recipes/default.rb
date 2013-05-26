package "php5"
package "php5-fpm"
package "php5-common"
package "php5-dev"
package "php5-gd"
package "php5-xcache"
package "php5-mcrypt"
package "php5-pspell"
package "php5-snmp"
package "php5-xsl"
package "php5-imap"
package "php5-geoip"
package "php5-curl"
package "php5-cli"

# Create the socket directory for PHP-FPM.
bash "install-nginx-repository" do
  code <<-EOH
  mkdir /var/run/php5-fpm
  EOH
  not_if { File.directory?("/var/run/php5-fpm") }
end

template "/etc/php5/fpm/pool.d/default_nginx.conf" do
  source "php5-fpm-nginx.conf.erb"
  mode 0440
  owner "root"
  group "root"
end
