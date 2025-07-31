# @summary A class to add the official HashiCorp package repository
#
# This class adds the official HashiCorp package repository to a supported
# system. It fails when running on an unsupported distribution.
#
# @param ensure
#
# @example
#   include hashicorp_repo
#
class hashicorp_repo (
  Enum['present', 'absent'] $ensure = 'present',
) {
  $architecture = $facts['os']['architecture'] ? {
    'aarch64' => 'arm64',
    default   => $facts['os']['architecture'],
  }

  case $facts['os']['family'] {
    'Debian': {
      apt::source { 'hashicorp':
        ensure       => $ensure,
        comment      => 'Official HashiCorp package repository',
        location     => 'https://apt.releases.hashicorp.com',
        architecture => $architecture,
        release      => $facts['os']['distro']['codename'],
        repos        => 'main',
        key          => {
          'name'   => 'hashicorp.asc',
          'source' => 'https://apt.releases.hashicorp.com/gpg',
        },
      }
    }

    'RedHat': {
      #
      # Hashicorp has specific repos for Fedora and Amazon Linux, but the names
      # don't match with $facts['os']['name'] for those distributions.
      #
      $os_name = $facts['os']['name'] ? {
        'Fedora' => 'fedora',
        'Amazon' => 'AmazonLinux',
        default  => 'RHEL',
      }

      yumrepo { 'hashicorp':
        ensure        => $ensure,
        descr         => 'Official HashiCorp package repository',
        baseurl       => "https://rpm.releases.hashicorp.com/${os_name}/\$releasever/\$basearch/stable",
        gpgcheck      => 1,
        gpgkey        => 'https://rpm.releases.hashicorp.com/gpg',
        repo_gpgcheck => true,
        enabled       => true,
      }
    }

    default: {
      fail(
        'This module (hashicorp_repo) only supports Debian and RedHat-based distributions'
      )
    }
  }
}
