default['apache']['package']     = 'httpd'
default['apache']['perl_pkg']    = 'perl'
default['apache']['dir']         = '/etc/httpd'
default['apache']['log_dir']     = '/var/log/httpd'
default['apache']['error_log']   = 'error.log'
default['apache']['access_log']  = 'access.log'
default['apache']['user']        = 'apache'
default['apache']['group']       = 'apache'
default['apache']['binary']      = '/usr/sbin/httpd'
default['apache']['docroot_dir'] = '/var/www/html'
default['apache']['cgibin_dir']  = '/var/www/cgi-bin'
default['apache']['icondir']     = '/var/www/icons'
default['apache']['cache_dir']   = '/var/cache/httpd'
default['apache']['pid_file']    = if node['platform_version'].to_f >= 6
                                     '/var/run/httpd/httpd.pid'
                                   else
                                     '/var/run/httpd.pid'
                                   end
default['apache']['lib_dir']     = node['kernel']['machine'] =~ /^i[36]86$/ ? '/usr/lib/httpd' : '/usr/lib64/httpd'
default['apache']['libexecdir']  = "#{node['apache']['lib_dir']}/modules"
default['apache']['default_site_enabled'] = false

# These settings need the unless, since we want them to be tunable,
# and we don't want to override the tunings.
###

# General settings
default['apache']['listen_addresses']  = %w[*]
default['apache']['listen_ports']      = %w[80]
default['apache']['contact']           = 'ops@example.com'
default['apache']['timeout']           = 300
default['apache']['keepalive']         = 'On'
default['apache']['keepaliverequests'] = 100
default['apache']['keepalivetimeout']  = 5
default['apache']['sysconfig_additional_params'] = {}

# Security
default['apache']['servertokens']    = 'Prod'
default['apache']['serversignature'] = 'On'
default['apache']['traceenable']     = 'On'

# Prefork Attributes
default['apache']['prefork']['startservers']        = 16
default['apache']['prefork']['minspareservers']     = 16
default['apache']['prefork']['maxspareservers']     = 32
default['apache']['prefork']['serverlimit']         = 400
default['apache']['prefork']['maxclients']          = 400
default['apache']['prefork']['maxrequestsperchild'] = 10_000

# Worker Attributes
default['apache']['worker']['startservers']        = 4
default['apache']['worker']['serverlimit']         = 16
default['apache']['worker']['maxclients']          = 1024
default['apache']['worker']['minsparethreads']     = 64
default['apache']['worker']['maxsparethreads']     = 192
default['apache']['worker']['threadsperchild']     = 64
default['apache']['worker']['maxrequestsperchild'] = 0

# mod_proxy settings
default['apache']['proxy']['order']      = 'deny,allow'
default['apache']['proxy']['deny_from']  = 'all'
default['apache']['proxy']['allow_from'] = 'none'

# Default modules to enable via include_recipe
default['apache']['default_modules'] = %w[
  status alias auth_basic authn_file authz_default authz_groupfile authz_host authz_user autoindex
  dir env mime negotiation setenvif
]
