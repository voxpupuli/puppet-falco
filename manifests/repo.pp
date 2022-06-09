# @summary Manages the repository falco is installed from
#
# Manages the repository falco is installed from
#
class falco::repo inherits falco {
  case $facts['os']['family'] {
    'Debian': {
      include apt

      Apt::Source['falco']
      -> Class['apt::update']

      apt::source { 'falco':
        location => 'https://download.falco.org/packages/deb',
        release  => 'stable',
        repos    => 'main',
        key      => {
          source => 'https://falco.org/repo/falcosecurity-3672BA8F.asc',
          id     => '3672BA8F',
        },
      }

      ensure_packages(["linux-headers-${facts['kernelrelease']}"])
    }
    'RedHat': {
      include 'epel'

      Yumrepo['falco']
      -> Class['epel']

      yumrepo { 'falco':
        baseurl  => 'https://download.falco.org/packages/rpm',
        descr    => 'Falco repository',
        enabled  => 1,
        gpgcheck => 0,
      }

      ensure_packages(["kernel-devel-${facts['kernelrelease']}"])
    }
    'Suse': {
      if $facts['os']['release']['full'] == '12.5' {
        rpmkey { '3A6A4D911FCCBD0A':
          ensure => present,
          source => 'https://download.opensuse.org/repositories/home:/BuR_Industrial_Automation:/SLE-12-SP5:/basesystem/SLE_12_SP5/repodata/repomd.xml.key',
          before => Zypprepo['home:BuR_Industrial_Automation:SLE-12-SP5:basesystem (SLE_12_SP5)'],
        }

        zypprepo { 'home:BuR_Industrial_Automation:SLE-12-SP5:basesystem (SLE_12_SP5)':
          name        => 'home:BuR_Industrial_Automation:SLE-12-SP5:basesystem (SLE_12_SP5)',
          enabled     => 1,
          autorefresh => 0,
          baseurl     => 'https://download.opensuse.org/repositories/home:/BuR_Industrial_Automation:/SLE-12-SP5:/basesystem/SLE_12_SP5/',
          type        => 'rpm-md',
          gpgcheck    => 1,
          gpgkey      => 'https://download.opensuse.org/repositories/home:/BuR_Industrial_Automation:/SLE-12-SP5:/basesystem/SLE_12_SP5/repodata/repomd.xml.key',
        }
      }

      rpmkey { '3672BA8F':
        ensure => present,
        source => 'https://falco.org/repo/falcosecurity-3672BA8F',
        before => Zypprepo['falcosecurity-rpm'],
      }

      zypprepo { 'falcosecurity-rpm':
        name          => 'falcosecurity-rpm',
        baseurl       => 'https://download.falco.org/packages/rpm',
        gpgcheck      => 1,
        gpgkey        => 'https://falco.org/repo/falcosecurity-3672BA8F',
        repo_gpgcheck => 0,
        enabled       => 1,
      }

      ensure_packages(['kernel-default-devel'])
    }
    default: {
      fail("\"${module_name}\" provides no repository information for OSfamily \"${facts['os']['family']}\"")
    }
  }
}
