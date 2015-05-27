require 'spec_helper'

describe 'Consul' do
  describe service('consul') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/consul.conf') do
    it { should be_file }
    its(:content) { should match /"server": true/ }
  end

  describe file('/etc/init/consul.conf') do
    it { should be_file }
    its(:content) { should match /export GOMAXPROCS=`nproc`/ }
  end

  describe file('/var/log/consul') do
    it { should be_file }
  end
end