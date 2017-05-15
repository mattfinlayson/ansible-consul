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
$ ansible-galaxy install savagegus.ansible-consul
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
consul_ui_nginx_template: "consul-nginx.conf.j2"
consul_ui_auth_user_file: /etc/htpasswd/consul
consul_ui_server_port: 80
consul_install_nginx: true
consul_install_nginx_config: true
consul_enable_nginx_config: true
consul_service_state: restarted

consul_install_consul_cli: false
consul_cli_archive: "master.zip"
consul_cli_download: "https://github.com/CiscoCloud/consul-cli/archive/{{ consul_cli_archive }}"

consul_home: /opt/consul
consul_config_dir: /etc/consul.d
consul_config_file: /etc/consul.conf
consul_log_file: /var/log/consul
consul_data_dir: "{{ consul_home }}/data"

consul_dns_allow_stale: false
consul_dns_max_stale: 5s
consul_dns_node_ttl: 0s
consul_dns_service_ttl: 0s
consul_dns_enable_truncate: false
consul_dns_only_passing: false
consul_recursors: []

consul_upstart_template: "consul.conf.j2"
consul_systemd_template: "consul.systemd.j2"
consul_initd_template: "consul.initd.sh.j2"
consul_dnsmasq_upstream_template: "resolv_dnsmasq.conf.j2"
consul_kv_template: "consulkv.j2"
consul_add_path_template: "consul.sh.j2"
consul_config_template: "consul.json.j2"

consul_binary: consul

consul_user: consul
consul_group: consul

consul_use_systemd: false
consul_use_upstart: true
consul_use_initd: false

consul_is_server: false

consul_domain: consul.

consul_servers: ['127.0.0.1']
consul_log_level: "INFO"
consul_syslog: false
consul_rejoin_after_leave: true
consul_leave_on_terminate: false

consul_join_at_start: false
consul_retry_join: false
consul_retry_interval: 30s
consul_retry_max: 0

consul_retry_join_ec2: false
consul_retry_join_gce: false

consul_servers_wan: []
consul_join_wan: false
consul_retry_join_wan: false
consul_retry_interval_wan: 30s
consul_retry_max_wan: 0
consul_advertise_address_wan: false
consul_advertise_address: "127.0.0.1" - default: `undefined`. If this variable is not defined it is not set in the config
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
consul_dnsmasq:
  listen_interface:
    - lo
    - docker0
    - eth0
  no_dhcp_interface:
    - lo
    - docker0
    - eth0
  upstream_servers:
    - 8.8.8.8
    - 8.8.4.4
consul_node_name: "{{ inventory_hostname }}"
consul_verify_server_hostname: false
consul_cors_support: false
consul_disable_update_check: false
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
consul_cert_file: "{{ consul_home }}/cert/consul.crt"
consul_key_file: "{{ consul_home }}/cert/consul.key"
consul_ca_file: "{{ consul_home }}/cert/ca.crt"
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
# if you don't want to prepend runtime telemetry with the machine's hostname (consul 0.6.4 or later)
consul_telemetry_disable_hostname: true
```

## DNS Variables
Consul provides the ability to use it as a [DNS resolver](https://www.consul.io/docs/agent/dns.html) for service and node lookups. To enable [dns_config](https://www.consul.io/docs/agent/options.html#dns_config) with the below default values, set the `consul_dns_config` variable to `true`

```yml
consul_dns_allow_stale: false
consul_dns_max_stale: 5s
consul_dns_node_ttl: 0s
consul_dns_service_ttl: 0s
consul_dns_enable_truncate: false
consul_udp_answer_limit: 3
consul_dns_only_passing: false
consul_recursors:
  - 8.8.8.8
  - 8.8.4.4
```

## ACL Variables

You can configure Consul to use [ACL](https://www.consul.io/docs/internals/acl.html)'s.

Below are some variables that you can use to set it up. See the [official documentation](https://www.consul.io/docs/agent/options.html#acl_datacenter) for their meaning.

Variables available for use, not defined by default:
```yml
consul_acl_enforce_version_8: false
consul_acl_datacenter: 'test'
consul_acl_default_policy: 'allow'
consul_acl_down_policy: 'allow'
consul_acl_master_token: 'generated_uuid_here'
consul_acl_token: 'generated_uuid_here'
consul_acl_ttl: 30
consul_atlas_acl_token: 'anonymous'
```


## Cross-origin Resource Sharing
Consul allows adding headers to the HTTP API responses, to enable [CORS](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing) set the `consul_cors_support` variable to `true`

```yml
consul_cors_support: true
```
## Shutdown behavior
Consul may be configured to perform (or not) cluster leave when it recieves TERM/INT signals.

When service is stopped:
 * systemd sends INT
 * init (init.d script) sends TERM
 * upstart sends TERM

There are two variables that define if the node will attempt cluster leave when it recieves those signals:

 * `consul_leave_on_terminate` defines if leave is performed when TERM is recieved. default: `false`
 * `consul_skip_leave_on_interrupt` defines if leave is **not** performed when INT is recieved. default: `undefined`. If this variable is not defined default consul behavior (which depends on version and server/agent role) will be used.

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

## Example playbook that configures a Consul server on Ubuntu with [runit](https://github.com/gitinsky/ansible-role-runit)
```yml
- hosts: all
  vars:
    consul_reload_config_handler: runit reload consul
    consul_restart_handler: runit restart consul
    consul_log_file: /dev/null
  roles:
    - ansible-consul
    - role: runit
      runit_pre_start_command: "setcap CAP_NET_BIND_SERVICE=+eip /opt/consul/bin/consul"
      runit_service_command: "/opt/consul/bin/consul"
      runit_service_params: "agent -config-dir /etc/consul.d -config-file=/etc/consul.conf"
      runit_service_env:
        GOMAXPROCS: "{{ ansible_processor_vcpus }}"
```

Logs will be handled by runit and ```consul_log_file``` set to ```/dev/null``` just to prevent ```/var/log/consul``` file creation as it conflicts with runit logs directory.

## Example playbooks that configures a Consul server on CentOS 7

```yml
---

- hosts: all
  vars:
    consul_is_server: "true"
    consul_datacenter: "test"
    consul_bootstrap: "true"
    consul_bind_address: "{{ ansible_default_ipv4['address'] }}"
    consul_use_upstart: false
    consul_use_systemd: true
    nginx_user: "nginx"
  roles:
    - ansible-consul
```

## Example to register consul services

```yml
consul_services:
  - service:
      name: "redis localhost"
      tags:
        - "redis"
      address: "127.0.0.1"
      port: 6379
      checks:
        - name: "Redis health check"
          tcp: "localhost:6379"
          interval: "10s"
          timeout: "1s"
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
Copyright (c) Matthew Finlayson under the Apache license.
