# Falco

[![Build Status](https://github.com/voxpupuli/puppet-falco/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-falco/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-falco/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-falco/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/falco.svg)](https://forge.puppetlabs.com/puppet/falco)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/falco.svg)](https://forge.puppetlabs.com/puppet/falco)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/falco.svg)](https://forge.puppetlabs.com/puppet/falco)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/falco.svg)](https://forge.puppetlabs.com/puppet/falco)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-falco)
[![Apache-2 License](https://img.shields.io/github/license/voxpupuli/puppet-falco.svg)](LICENSE)

Falco is a behavioral activity monitor designed to detect anomalous activity in your applications. Powered by [Falco libraries](https://github.com/falcosecurity/libs) system call capture and inspection infrastructure, Falco lets you continuously monitor and detect container, application, host, and network activity... all in one place, from one source of data, with one set of rules.

- [What kind of behaviors can Falco detect?](#what-kind-of-behaviors-can-falco-detect)
- [Module Description](#module-description)
- [Setup](#setup)
  - [Beginning with Falco](#beginning-with-falco)
- [Reference](#reference)
- [Limitations](#limitations)
- [Development](#development)
  - [History](#history)

## What kind of behaviors can Falco detect?

Falco can detect and alert on any behavior that involves making Linux system calls. Thanks to the Falco drivers,  `libscap` and `libsinsp` [Falco libraries](https://github.com/falcosecurity/libs) which capture, parse, enrich and filter collected system calls as a raw data source, Falco alerts can be triggered by the use of specific system calls, their arguments, and by properties of the calling process. For example, you can easily detect things like:

- A shell is run inside a container
- A container is running in privileged mode, or is mounting a sensitive path like `/proc` from the host.
- A server process spawns a child process of an unexpected type
- Unexpected read of a sensitive file (like `/etc/shadow`)
- A non-device file is written to `/dev`
- A standard system binary (like `ls`) makes an outbound network connection

## Module Description

This module configures Falco as a systemd service. You configure Falco to send its notifications to one or more output channels (syslog, files, programs).

## Setup

### Beginning with Falco

To have Puppet install Falco with the default parameters, declare the Falco class:

``` puppet
class { 'falco': }
```

When you declare this class with the default options, the module:

- Installs the appropriate Falco software package and installs the falco-probe kernel module for your operating system.
- Creates the required configuration file `/etc/falco/falco.yaml`.
- Manages the local rules file `/etc/falco/falco_rules.local.yaml`.
- Starts the Falco service.

## Reference

This module is documented via `bundle exec rake strings:generate:reference`. Please see [REFERENCE.md](REFERENCE.md) for more info and example usage.

## Limitations

The module works where Falco works as a daemonized service (generally, Linux only). Also, newer configuration options in `falco.yaml` may not have been templated yet... PRs welcome if you find such a case.

## Development

PRs are welcome!

### History

This module is derrived from [falcosecurity/evolution](https://github.com/falcosecurity/evolution/tree/33a3025d1dedc3a6fbea814b8f3f80d275d6e3f0/integrations/puppet-module/falco). That code came from [falcosecurity/falco](https://github.com/falcosecurity/falco) as part of resolving issue [#1114](https://github.com/falcosecurity/falco/issues/1114). The old code is the basis for [sysdig/falco](https://forge.puppet.com/modules/sysdig/falco). [#2005](https://github.com/falcosecurity/falco/issues/2005) was submitted to request that module be depreciated since it appears to be abondoned.
