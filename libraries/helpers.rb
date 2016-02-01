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

require 'shellwords'

module RhsmCookbook
  module RhsmHelpers
    def register_command # rubocop:disable Metrics/AbcSize
      command = %w(subscription-manager register)

      unless activation_keys.empty?
        raise 'Unable to register - must specify organization when using activation keys' if organization.nil?

        command << activation_keys.map { |key| "--activationkey=#{Shellwords.shellescape(key)}" }
        command << "--org=#{Shellwords.shellescape(organization)}"

        return command.join(' ')
      end

      if username && password
        raise 'Unable to register - must specify environment when using username/password' if environment.nil? && using_satellite_host?

        command << "--username=#{Shellwords.shellescape(username)}"
        command << "--password=#{Shellwords.shellescape(password)}"
        command << "--environment=#{Shellwords.shellescape(environment)}" if using_satellite_host?
        command << '--auto-attach' if auto_attach

        return command.join(' ')
      end

      raise 'Unable to create register command - must specify activation_key or username/password'
    end

    def using_satellite_host?
      !satellite_host.nil?
    end

    def activation_keys
      Array(activation_key)
    end

    def registered_with_rhsm?
      cmd = Mixlib::ShellOut.new('subscription-manager status')
      cmd.run_command
      !cmd.stdout.match(/Overall Status: Unknown/)
    end

    def katello_cert_rpm_installed?
      cmd = Mixlib::ShellOut.new('rpm -qa | grep katello-ca-consumer')
      cmd.run_command
      !cmd.stdout.match(/katello-ca-consumer/).nil?
    end

    def subscription_attached?(subscription)
      cmd = Mixlib::ShellOut.new("subscription-manager list --consumed | grep #{subscription}")
      cmd.run_command
      !cmd.stdout.match(/Pool ID:\s+#{subscription}$/).nil?
    end

    def repo_enabled?(repo)
      cmd = Mixlib::ShellOut.new('subscription-manager repos --list-enabled')
      cmd.run_command
      !cmd.stdout.match(/Repo ID:\s+#{repo}$/).nil?
    end

    def validate_errata_level!(level)
      raise "Invalid errata level: #{level.downcase} - must be: critical, moderate, important, or low" unless
        %w(critical moderate important low).include?(level.downcase)
    end

    def serials_by_pool
      serials = {}
      pool = nil
      serial = nil

      cmd = Mixlib::ShellOut.new('subscription-manager list --consumed')
      cmd.run_command
      cmd.stdout.lines.each do |line|
        line.strip!
        key, value = line.split(/:\s+/, 2)
        next unless [ 'Pool ID', 'Serial' ].include?(key)

        if key == 'Pool ID'
          pool = value
        elsif key == 'Serial'
          serial = value
        end

        next unless pool && serial

        serials[pool] = serial
        pool = nil
        serial = nil
      end

      serials
    end

    def pool_serial(pool_id)
      serials_by_pool[pool_id]
    end
  end
end
