# hashicorp_repo

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with hashicorp_repo](#setup)
    * [What hashicorp_repo affects](#what-hashicorp_repo-affects)
    * [Beginning with hashicorp_repo](#beginning-with-hashicorp_repo)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module is used to add the official HashiCorp package repository to a
Puppet-managed machine.

## Setup

### What hashicorp_repo affects

This module will add an apt or yum repository, depending on os family.

### Beginning with hashicorp_repo

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most basic
use of the module.

## Usage

This module is very simple to use.

```puppet
if $facts['os']['family'] in ['Debian', 'RedHat'] {
 include hashicorp_repo
}
```

## Limitations

This module can only support the distributions and versions that HashiCorp
has official repositories for. It will fail if you try to use it on say,
FreeBSD.

## Development

Contributions are welcome, but all code must be idiomatic puppet code and must
also be accompanied by unit tests.
