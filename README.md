# Ansible Consul Role

`consul` is an [ansible](http://www.ansible.com) role which:

 * installs consul
 * configures consul
 * installs consul ui
 * configures consul ui
 * optionally installs dnsmasq
 * optionally install consulate
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
consul_version: 0.5.2
consul_archive: "{{ consul_version }}_linux_amd64.zip"
consul_download: "https://dl.bintray.com/mitchellh/consul/{{ consul_archive }}"
consul_download_folder: /tmp

consul_is_ui: false
consul_ui_archive: "{{ consul_version }}_web_ui.zip"
consul_ui_download: "https://dl.bintray.com/mitchellh/consul/{{ consul_ui_archive }}"
consul_ui_dir: "{{ consul_home }}/dist"
consul_ui_server_name: "{{ ansible_fqdn }}"
consul_ui_require_auth: false
consul_ui_auth_user_file: /etc/htpasswd/consul
consul_enable_nginx_config: true

consul_home: /opt/consul
consul_config_dir: /etc/consul.d
consul_config_file: /etc/consul.conf
consul_log_file: /var/log/consul
consul_data_dir: "{{ consul_home }}/data"

consul_binary: consul

consul_user: consul
consul_group: consul

consul_is_server: false

consul_domain: consul.

consul_servers: ['127.0.0.1']
consul_log_level: "INFO"
consul_syslog: false
consul_rejoin_after_leave: true
consul_leave_on_terminate: false
consul_bind_address: "0.0.0.0"
consul_dynamic_bind: false
consul_client_address: "127.0.0.1"
consul_client_address_bind: false
consul_datacenter: "default"
consul_disable_remote_exec: true

consul_install_dnsmasq: false
consul_install_consulate: false
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

## Other Variables

```yml
# if you Consul to send metrics to a statsd instance
consul_statsd_address: "127.0.0.1"
```


## Handlers

These are the handlers that are defined in `handlers/main.yml`.

* `restart consul` 
* `restart dnsmasq` 

## Example playbook

```yml
---

- hosts: all
  roles:
    - ansible-consul
  vars:
    consul_is_ui: "true"
    consul_is_server: "true"
    consul_datacenter: "test"
    consul_bootstrap: "true"
    consul_node_name: "vagrant"
    consul_bind_address: "{{ ansible_default_ipv4['address'] }}"
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
