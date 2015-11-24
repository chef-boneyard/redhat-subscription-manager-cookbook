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
  class RhsmRepo < ChefCompat::Resource
    include RhsmCookbook::RhsmHelpers

    resource_name :rhsm_repo

    property :repo_name, kind_of: String, name_property: true

    action :enable do
      execute "Enable repository #{repo_name}" do
        command "subscription-manager repos --enable=#{repo_name}"
        action :run
        not_if { repo_enabled?(repo_name) }
      end
    end

    action :disable do
      execute "Enable repository #{repo_name}" do
        command "subscription-manager repos --disable=#{repo_name}"
        action :run
        only_if { repo_enabled?(repo_name) }
      end
    end
  end
end
