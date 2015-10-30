package 'apache2' do
  package_name node['apache']['package']
end


  directory node['apache']['log_dir'] do
    mode '0755'
  end

  package node['apache']['perl_pkg']

  cookbook_file '/usr/local/bin/apache2_module_conf_generate.pl' do
    source 'apache2_module_conf_generate.pl'
    mode   '0755'
    owner  'root'
    group  node['apache']['root_group']
  end

  %w[sites-available sites-enabled mods-available mods-enabled].each do |dir|
    directory "#{node['apache']['dir']}/#{dir}" do
      mode  '0755'
      owner 'root'
      group node['apache']['root_group']
    end
  end

  execute 'generate-module-list' do
    command "/usr/local/bin/apache2_module_conf_generate.pl #{node['apache']['lib_dir']} #{node['apache']['dir']}/mods-available"
    action  :nothing
  end

  %w[a2ensite a2dissite a2enmod a2dismod].each do |modscript|
    template "/usr/sbin/#{modscript}" do
      source "#{modscript}.erb"
      mode  '0700'
      owner 'root'
      group node['apache']['root_group']
    end
  end

  # installed by default on centos/rhel, remove in favour of mods-enabled
  %w[proxy_ajp auth_pam authz_ldap webalizer ssl welcome].each do |f|
    file "#{node['apache']['dir']}/conf.d/#{f}.conf" do
      action :delete
      backup false
    end
  end

  # installed by default on centos/rhel, remove in favour of mods-enabled
  file "#{node['apache']['dir']}/conf.d/README" do
    action :delete
    backup false
  end

  # enable mod_deflate for consistency across distributions
  apache_module 'deflate' do
    conf true
  end
