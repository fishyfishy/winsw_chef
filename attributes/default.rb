default['winsw']['wrapper']['version']                = '1.19.1'
default['winsw']['wrapper']['exe']                    = "winsw-#{node['winsw']['wrapper']['version']}-bin.exe"
default['winsw']['download']['site']                  = 'http://repo.jenkins-ci.org/releases/com/sun/winsw/winsw'
default['winsw']['exe']['url']                        = "#{node['winsw']['download']['site']}/#{node['winsw']['wrapper']['version']}/#{node['winsw']['wrapper']['exe']}"
