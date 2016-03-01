if defined?(ChefSpec)
  def register_rhsm_register(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rhsm_register, :register, resource_name)
  end

  def unregister_rhsm_register(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rhsm_register, :unregister, resource_name)
  end

  def install_rhsm_errata(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rhsm_errata, :install, resource_name)
  end

  def install_rhsm_errata_level(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rhsm_errata_level, :install, resource_name)
  end

  def enable_rhsm_repo(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rhsm_repo, :enable, resource_name)
  end

  def disable_rhsm_repo(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rhsm_repo, :disable, resource_name)
  end

  def attach_rhsm_subscription(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rhsm_subscription, :attach, resource_name)
  end

  def remove_rhsm_subscription(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rhsm_subscription, :remove, resource_name)
  end
end
