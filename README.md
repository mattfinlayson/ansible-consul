# Ansible Consul Role

`consul` is an [ansible](http://www.ansible.com) role which:

 * installs consul
 * configures consul
 * optionally installs and configures consul ui
 * optionally installs dnsmasq
 * optionally install consulate
 * optionally install consul-cli
 * configures consul service(s)

## Installation

Using `ansible-galaxy`:

```
$ ansible-galaxy install savagegus.consul
```

Using `arm` ([Ansible Role Manager](https://github.com/mirskytech/ansible-role-manager/)):

```
$ arm install savagegus.consul
```

Using `git`:

```
$ git clone https://github.com/jivesoftware/ansible-consul.git
```

## Variables

Here is a list of all the default variables for this role, which are also available in `defaults/main.yml`.

```yml
---
consul_version: 0.6.0
consul_archive: "consul_{{ consul_version }}_linux_amd64.zip"
consul_download: "https://releases.hashicorp.com/consul/{{ consul_version }}/{{ consul_archive }}"
consul_download_username: ""
consul_download_password: ""
consul_download_folder: /tmp

consul_is_ui: false
consul_ui_archive: "consul_{{ consul_version }}_web_ui.zip"
consul_ui_download: "https://releases.hashicorp.com/consul/{{ consul_version }}/{{ consul_ui_archive }}"
consul_ui_dir: "{{ consul_home }}/dist"
consul_ui_server_name: "{{ ansible_fqdn }}"
consul_ui_require_auth: false
consul_ui_auth_user_file: /etc/htpasswd/consul
consul_install_nginx: true
consul_install_nginx_config: true
consul_enable_nginx_config: true

consul_install_consul_cli: false
consul_cli_archive: "master.zip"
consul_cli_download: "https://github.com/CiscoCloud/consul-cli/archive/{{ consul_cli_archive }}"

consul_home: /opt/consul
consul_config_dir: /etc/consul.d
consul_config_file: /etc/consul.conf
consul_log_file: /var/log/consul
consul_data_dir: "{{ consul_home }}/data"

consul_upstart_template: "consul.conf.j2"
consul_systemd_template: "consul.systemd.j2"

consul_binary: consul

consul_user: consul
consul_group: consul

consul_use_systemd: false
consul_use_upstart: true

consul_is_server: false

consul_domain: consul.

consul_servers: ['127.0.0.1']
consul_log_level: "INFO"
consul_syslog: false
consul_rejoin_after_leave: true
consul_leave_on_terminate: false
consul_join_at_start: false

consul_bind_address: "0.0.0.0"
consul_dynamic_bind: false
consul_client_address: "127.0.0.1"

consul_client_address_bind: false
consul_datacenter: "default"
consul_disable_remote_exec: true

consul_port_dns: 8600
consul_port_http: 8500
consul_port_https: -1
consul_port_rpc: 8400
consul_port_serf_lan: 8301
consul_port_serf_wan: 8302
consul_port_server: 8300

consul_install_dnsmasq: false
consul_install_consulate: false

consul_node_name: "{{ inventory_hostname }}"
```

An instance might be defined through:

```yml
# enable ui
consul_is_ui: true
# start as a server
consul_is_server: true
# name datacenter
consul_datacenter: test
# bootstrap
consul_bootstrap: true
# name the node
consul_node_name: vagrant
# bind to ip
consul_bind_address: "{{ ansible_default_ipv4['address'] }}"
# encrypt using string from consul keygen
consul_encrypt: "X4SYOinf2pTAcAHRhpj7dA=="
```

## Enable TLS encryption

See [https://www.consul.io/docs/agent/encryption.html](https://www.consul.io/docs/agent/encryption.html) for details.

These files will be created on your Consul host:

```yml
consul_cert_file: "{{ consul_home }}/cert/consul.crt",
consul_key_file: "{{ consul_home }}/cert/consul.key",
consul_ca_file: "{{ consul_home }}/cert/ca.crt",
```

When you provide these vars. You should use Ansible Vault to encrypt these vars or perhaps pass them on the command line.

```yml
consul_tls_cert: |
  CERT CONTENTS HERE

consul_tls_key: |
  KEY CONTENTS HERE

consul_tls_ca_cert: |
  CERT CONTENTS HERE
```

## Atlas Variables

```yml
consul_atlas_infrastructure: "your_infrastructure_name"
consul_atlas_token: "your_consul_token"

# if you want to use Atlas autodiscovery for clustering
consul_atlas_join: true
```

## Telemetry Variables
Consul has excellent [telemetry support](https://www.consul.io/docs/agent/telemetry.html). To enable it, use any of the following variables:

```yml
# if you want Consul to send metrics to a statsd instance
consul_statsd_address: "127.0.0.1:8125"
# if you want Consul to send metrics to a statsite instance
consul_statsite_address: "127.0.0.1:8125"
# this sets the prefix consul uses for all metrics
consul_statsite_prefix: "consul"
```

## DNS Variables
Consul provides the ability to use it as a [DNS resolver](https://www.consul.io/docs/agent/dns.html) for service and node lookups. To enable [dns_config](https://www.consul.io/docs/agent/options.html#dns_config) with the below default values, set the `consul_dns_config` variable to `true`

```yml
consul_dns_allow_stale: false
consul_dns_max_stale: 5s
consul_dns_node_ttl: 0s
consul_dns_service_ttl: 0s
consul_dns_enable_truncate: false
consul_dns_only_passing: false
```

## Handlers

These are the handlers that are defined in `handlers/main.yml`.

* `restart consul`
* `restart dnsmasq`
* `reload consul config`
* `reload systemd`

## Example playbook that configures a Consul server on Ubuntu

```yml
---

- hosts: all
  vars:
    consul_is_server: "true"
    consul_datacenter: "test"
    consul_bootstrap: "true"
    consul_bind_address: "{{ ansible_default_ipv4['address'] }}"
  roles:
    - ansible-consul
```

## Example playbooks that configures a Consul server on CentOS 7

```yml
---

- hosts: all
  vars:
    consul_is_server: "true"
    consul_datacenter: "test"
    consul_bootstrap: "true"
    consul_bind_address: "{{ ansible_default_ipv4['address'] }}"
    consul_use_systemd: true
  roles:
    - ansible-consul
```


## Testing

```
$ git clone https://github.com/jivesoftware/ansible-consul.git
$ cd ansible-consul
$ ansible-galaxy install --role-file=requirements.yml --roles-path=roles --force
$ vagrant up
```

or use the TestKitchen tests

```
$ bundle
$ rm -rf roles
$ bundle exec kitchen test
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests and examples for any new or changed functionality.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
Copyright (c) Jive Software under the Apache license.
