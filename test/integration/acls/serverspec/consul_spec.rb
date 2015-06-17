require 'spec_helper'

describe 'Consul' do
  describe service('consul') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/consul.conf') do
    its(:content) { should match /"acl_datacenter": \"my_datacenter\"/ }
    its(:content) { should match /"acl_default_policy": \"deny\"/ }
    its(:content) { should match /"acl_down_policy": \"extend-cache\"/ }
    its(:content) { should match /"acl_master_token": \"my_bogus_token\"/ }
    its(:content) { should match /"acl_token": \"my_bogus_agent_token\"/ }
    its(:content) { should match /"acl_ttl": \"5m\"/ }
    its(:content) { should match /"atlas_acl_token": \"my_bogus_atlas_token\"/ }
  end
end