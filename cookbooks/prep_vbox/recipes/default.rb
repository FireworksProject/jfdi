bash "kill apache" do
  code <<-EOH
  service apache2 stop
  apt-get remove apache2
  EOH
end

bash "clean packages" do
  code <<-EOH
  apt-get autoremove
  apt-get autoclean
  EOH
end
