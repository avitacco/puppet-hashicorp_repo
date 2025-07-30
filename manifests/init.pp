# @summary A class to add the official HashiCorp package repository
#
# This class adds the official HashiCorp package repository to a supported
# system. It fails when running on an unsupported distribution.
#
# @example
#   include hashicorp_repo
#
class hashicorp_repo {
  $architecture = $facts['os']['architecture'] ? {
    'aarch64' => 'arm64',
    default   => $facts['os']['architecture'],
  }

  case $facts['os']['family'] {
    'Debian': {
      apt::source { 'hashicorp':
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
      # TODO: add redhat support
    }

    default: {
      fail(
        'This module (hashicorp_repo) only supports Debian and RedHat-based distributions'
      )
    }
  }
}
