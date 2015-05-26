require 'spec_helper'

describe 'Consul' do
  describe service('consul') do
    it { should be_enabled }
  end

  describe file('/etc/consul.conf') do
    it { should be_file }
    its(:content) { should match /"server": true/ }
    its(:content) { should match /"atlas_infrastructure": "test_infrastructure"/ }
    its(:content) { should match /"atlas_token": "a_fake_token_value"/ }
    its(:content) { should match /"atlas_join": true/ }
  end
end