# @summary
#
# Installs the falco package
#
class falco::install inherits falco {
  package { 'falco':
    ensure => $falco::package_ensure,
  }
}
