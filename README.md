redhat_subscription_manager cookbook
====================================

The Red Hat Subscription Manager (RHSM) cookbook provides custom resources
for use in recipes to interact with RHSM or a locally-installed Red Hat
Satellite.  These resources allow you to configure your hosts' registration
status, repo status, and installation of errata.

Scope
-----
This cookbook focuses on Red Hat Enterprise Linux hosts with support for
the `subscription-manager` tool and the new style of registration and
subscription management.  It does not support the former `rhn_register` or
`spacewalk-channel` method of channel registration.

Requirements
------------
- Chef 12.0.0 or higher
- Outbound internet access (if not using a locally-accessible Satellite)
- Outbound access to the Satellite host (if using a Satellite)
- Valid Red Hat entitlements/subscriptions

Usage
-----
Place a dependency on the `redhat_subscription_manager` cookbook in your
cookbook's metadata.rb:

```ruby
depends 'redhat_subscription_manager', '~> 0.1'
```

Then, in a recipe:

```ruby
rhsm_register 'myhost' do
  activation_key 'mykey1234'
  satellite_host 'satellite.mycompany.com'
  action :register
end
```

Resources
---------

### rhsm_register

The `rhsm_register` resource performs the necessary tasks to register your host
with RHSM or your local Satellite server.

#### Actions

* **:register**: (default) registers your host
* **:unregister**: unregisters your host

#### Parameters

* **activation_key**: string of the activation key to use when registering, or an array of keys if multiple keys are needed.  When using `activation_key`, you must supply an `organization`.
* **satellite_host**: (optional) FQDN of the Satellite host to register with.  If not specified, the host will be registered with Red Hat's public RHSM service.
* **organization**: organization to use when registering, required when using an activation key
* **username**: username to use when registering. Not applicable if using an activation key. If specified, password and environment are also required.
* **password**: password to use when registering. Not applicable if using an activation key. If specified, username and environment are also required.
* **environment**: environment to use when registering, required when using username and password
* **auto_attach**: if true, RHSM will attempt to automatically attach the host to applicable subscriptions. It is generally better to use an activation key with the subscriptions pre-defined.
* **install_katello_agent**: if true, the `katello-agent` RPM will be installed. Defaults to `true`
* **sensitive**: if true, the execution of the registration command will be flagged as "sensitive," prohibiting the command, STDOUT, and STDERR from being displayed in the Chef log output. This command could contain usernames, passwords, and activation keys, so unlike other Chef resources, this defaults to `true`. However, you may set it to `false` to get additional output if your registration attempts are failing.

#### Examples

```ruby
rhsm_register 'myhost' do
  satellite_host 'satellite.mycompany.com'
  activation_key [ 'key1', 'key2' ]
end

rhsm_register 'myhost' do
  username 'myuser'
  password 'mypassword'
  environment 'myenvironment'
  auto_attach true
end

rhsm_register 'myhost' do
  action :unregister
end
```

### rhsm_subscription

The `rhsm_subscription` resource will add another subscription to your host.
This can be used when a host's activation_key does not attach all necessary
subscriptions to your host.

#### Actions

* **:attach**: (default) attach a new subscription
* **:remove**: remove an existing Subscription

#### Parameters

None.  The name passed in to the resource will be the pool ID to use when
attaching/removing.

#### Examples

```ruby
rhsm_subscription 'pool123' do
  action :attach
end

rhsm_subscription 'pool321' do
  action :remove
end
```

### rhsm_repo

The `rhsm_repo` resource enabled and disables repositories that are made
available via attached subscriptions.

#### Actions

* **:enable**: (default) enable a repo
* **:disable**: disable a repo

#### Parameters

None.  The name passed in to the resource will be the repository name to use
when enabling/disabling.

#### Examples

```ruby
rhsm_repo 'rhel-7-myrepo' do
  action :enable
end

rhsm_repo 'rhel-7-oldrepo' do
  action :disable
end
```

### rhsm_errata

The `rhsm_errata` resource will ensure packages associated with a given Errata
ID are installed.  This is helpful if packages to mitigate a single vulnerability
must be installed on your hosts.

#### Actions

* **:install**: (default) install all packages for a given erratum

#### Parameters

None.  The name passed in to the resource will be the Errata ID to use when
installing packages.

#### Examples

```ruby
rhsm_errata 'RHSA:2015-1234'

rhsm_errata 'RHSA:2015-4321' do
  action :install
end
```

### rhsm_errata_level

The `rhsm_errata_level` resource will install all packages for all errata
of a certain security level. For example, you can ensure that all packages
associated with errata marked at a "Critical" security level are installed.

#### Actions

* **:install**: (default) install all packages for all errata of a certain security level

#### Parameters

None.  The name passed in to the resource will be the security level to use when
installing packages.

Valid security levels are: critical, moderate, important, and low. While `yum`
is case sensitive, the values expected by this cookbook are not.

#### Examples

```ruby
rhsm_errata_level 'critical'

rhsm_errata_level 'IMPORTANT' do
  action :install
end
```

License and Authors
-------------------

Author:: Chef Partner Engineering (<partnereng@chef.io>)

Copyright:: Copyright (c) 2015 Chef Software, Inc.

License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the License at

```
http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software distributed under the
License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
either express or implied. See the License for the specific language governing permissions
and limitations under the License.

Contributing
------------

1. Fork it ( https://github.com/chef-partners/redhat-subscription-manager-cookbook/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
