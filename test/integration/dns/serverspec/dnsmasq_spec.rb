require 'spec_helper'

describe 'dnsmasq' do
  describe service('dnsmasq') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/dnsmasq.d/10-consul') do
    it { should be_file }
    its(:content) { should match /server=\/consul.\/127.0.0.1#8200/ }
  end

  describe file('/etc/dnsmasq.conf') do
    its(:content) { should match /^interface=lo/ }
    its(:content) { should match /^no-dhcp-interface=lo/ }
  end
end
