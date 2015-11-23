name 'redhat_subscription_manager'
maintainer 'Chef Partner Engineering'
maintainer_email 'partnereng@chef.io'
license 'Apache 2.0'
description 'Provides custom resources to interact with Red Hat Subscription Manager (RHSM) and Red Hat Satellite'
long_description 'Provides custom resources to interact with Red Hat Subscription Manager (RHSM) and Red Hat Satellite'
version '0.1.0'
source_url 'https://github.com/chef-partners/redhat-subscription-manager-cookbook' if respond_to?(:source_url)
issues_url 'https://github.com/chef-partners/redhat-subscription-manager-cookbook/issues' if respond_to?(:issues_url)

depends 'compat_resource', '~> 12.5'
