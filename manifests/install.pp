# @summary
#
# Installs the falco package
#
class falco::install inherits falco {
  # Install dependencies
  $_suse_kernel_version = regsubst($facts['kernelrelease'], '^(.*)-default$', '\\1')
  $_running_kernel_package = $facts['os']['family'] ? {
    'Debian' => "linux-headers-${facts['kernelrelease']}",
    'RedHat' => "kernel-devel-${facts['kernelrelease']}",
    'Suse'   => "kernel-default-devel-${_suse_kernel_version}",
    default  => fail("The module \"${module_name}\" does not yet support \"${facts['os']['family']}\""),
  }

  $_package_deps = ['dkms', 'make', $_running_kernel_package]
  ensure_packages($_package_deps)

  package { 'falco':
    ensure  => $falco::package_ensure,
    require => Package[$_package_deps],
  }
}
