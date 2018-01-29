#
# Cookbook Name:: rhsm-test
# Recipe:: unit
# Author:: Chef Partner Engineering (<partnereng@chef.io>)
# Copyright:: 2015-2018 Chef Software, Inc.
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

rhsm_register 'myhost1' do
  activation_key 'key1'
  organization 'myorg'
  satellite_host 'satellite.corp.com'
  action :register
end

rhsm_subscription 'pool_to_add' do
  action :attach
end

rhsm_subscription 'pool_to_remove' do
  action :remove
end

rhsm_repo 'repo_to_add' do
  action :enable
end

rhsm_repo 'repo_to_remove' do
  action :disable
end

rhsm_errata 'errata1'

rhsm_errata_level 'Low'
