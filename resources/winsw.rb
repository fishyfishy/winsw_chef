require 'win32/service'

class Chef
  class Resource::WinSW < Resource

    resource_name :winsw

    default_action :install

    property :name, kind_of: String, name_attribute: true
    property :service_name, kind_of: String
    property :basedir, kind_of: String
    property :description, kind_of: String
    property :executable, kind_of: String, required: true
    property :args, kind_of: Array, default: []
    property :env_variables, kind_of: Hash, default: {}
    property :options, kind_of: Hash, default: {}
    property :supported_runtimes, kind_of: Array, default: %w( v2.0.50727 v4.0 )

    action :install do

      service_name = new_resource.service_name || new_resource.name
      service_base = "#{new_resource.basedir || Config[:file_cache_path]}/#{service_name}"
      service_exec = "#{service_base}/#{service_name}.exe".gsub('/', '\\')

      description = new_resource.description || new_resource.service_name

      directory service_base do
        recursive true
        action :create
      end

      # winsw will need to make use of the .NET Framework
      # powershell_script "#{new_resource.name} install .Net framework" do
      #   code 'Install-WindowsFeature Net-Framework-Core'
      #   only_if {
      #     new_resource.supported_runtimes.empty? || (new_resource.supported_runtimes.size == 1 && new_resource.supported_runtimes.include?('v2.0.50727'))
      #   }
      # end

      supported_runtime_config = ::File.join(service_base, "#{service_name}.exe.config")
      if new_resource.supported_runtimes.empty?
        file supported_runtime_config do
          action :delete
        end
      else
        template supported_runtime_config do
          cookbook 'winsw'
          source 'winsw.exe.config.erb'
          variables({
                        :supported_runtimes => new_resource.supported_runtimes
                    })
        end
      end

      remote_file "#{new_resource.name} download winsw" do
        source node['winsw']['exe']['url']
        path ::File.join(service_base, "#{service_name}.exe")
        action :create_if_missing
      end

      template ::File.join(service_base, "#{service_name}.xml") do
        cookbook 'winsw'
        source 'winsw.xml.erb'
        variables({
                      :service_name => "#{service_name}",
                      :description => "#{description}",
                      :executable => new_resource.executable,
                      :args => new_resource.args,
                      :env_variables => new_resource.env_variables,
                      :options => new_resource.options
                  })
        notifies :restart, "service[#{new_resource.name}]", :immediately
      end

      service new_resource.name do
        action :restart
        timeout 120
        only_if {::Win32::Service.exists?(new_resource.name)}
      end

      execute "#{new_resource.name} install" do
        command "#{service_exec} install"
        not_if {::Win32::Service.exists?(new_resource.name)}
      end

      service new_resource.name do
        action [:enable, :start]
        timeout 120
        only_if {::Win32::Service.exists?(new_resource.name)}
      end

    end

    action :uninstall do

      service_name = new_resource.service_name || new_resource.name
      service_base = "#{new_resource.basedir || Config[:file_cache_path]}/#{service_name}"
      service_exec = "#{service_base}/#{service_name}.exe".gsub('/', '\\')

      service new_resource.name do
        action :stop
        timeout 120
        only_if {::Win32::Service.exists?(new_resource.name)}
      end

      execute "#{new_resource.name} uninstall" do
        command "#{service_exec} uninstall"
        only_if {::Win32::Service.exists?(new_resource.name)}
      end

    end

  end
end
