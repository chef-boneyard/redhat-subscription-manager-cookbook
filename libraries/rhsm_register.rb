#
# Author:: Chef Partner Engineering (<partnereng@chef.io>)
# Copyright:: Copyright (c) 2015 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module RhsmCookbook
  class RhsmRegister < ChefCompat::Resource
    include RhsmCookbook::RhsmHelpers

    resource_name :rhsm_register

    property :_name_unused,          kind_of: String, name_property: true
    property :activation_key,        kind_of: [ String, Array ]
    property :satellite_host,        kind_of: String
    property :organization,          kind_of: String
    property :environment,           kind_of: String
    property :username,              kind_of: String
    property :password,              kind_of: String
    property :auto_attach,           kind_of: [ TrueClass, FalseClass ], default: false
    property :install_katello_agent, kind_of: [ TrueClass, FalseClass ], default: true
    property :sensitive,             kind_of: [ TrueClass, FalseClass ], default: true

    action :register do
      remote_file "#{Chef::Config[:file_cache_path]}/katello-package.rpm" do
        source "http://#{satellite_host}/pub/katello-ca-consumer-latest.noarch.rpm"
        action :create
        notifies :install, 'yum_package[katello-ca-consumer-latest]', :immediately
        not_if { satellite_host.nil? || registered_with_rhsm? || katello_cert_rpm_installed? }
      end

      yum_package 'katello-ca-consumer-latest' do
        options '--nogpgcheck'
        source "#{Chef::Config[:file_cache_path]}/katello-package.rpm"
        action :nothing
      end

      file "#{Chef::Config[:file_cache_path]}/katello-package.rpm" do
        action :delete
      end

      execute 'Register to RHSM' do # ~FC009
        sensitive new_resource.sensitive
        command register_command
        action :run
        not_if { registered_with_rhsm? }
      end

      yum_package 'katello-agent' do
        action :install
        only_if { install_katello_agent }
      end
    end

    action :unregister do
      execute 'Unregister from RHSM' do
        command 'subscription-manager unregister'
        action :run
        only_if { registered_with_rhsm? }
        notifies :run, 'execute[Clean RHSM Config]', :immediately
      end

      execute 'Clean RHSM Config' do
        command 'subscription-manager clean'
        action :nothing
      end
    end
  end
end
