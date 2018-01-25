#
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

require 'spec_helper'

describe 'rhsm-test::default' do
  it 'registered with Red Hat Satellite' do
    expect(command('subscription-manager').stdout).not_to match(/Overall Status: Unknown/)
  end

  it 'installed the katello-agent package' do
    expect(package('katello-agent')).to be_installed
  end

  it 'installed all Low-level errata' do
    expect(command('yum list-sec').stdout).not_to contain('Low/Sec.')
  end
end
