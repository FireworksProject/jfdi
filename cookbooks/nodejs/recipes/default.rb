bash "install-node" do
  code <<-EOH
  echo "boooya"
  EOH
  not_if "node --version 2>&1 | grep v0.10.8"
end
