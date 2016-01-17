require 'spec_helper'

describe 'Consul' do
  describe service('consul') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/var/log/consul') do
    it { should be_directory }
    it { should be_owned_by('consul') }
  end

  describe file('/var/log/consul/consul.log') do
    it { should be_file }
    it { should be_owned_by('consul') }
    its(:size) { should > 0 }
  end
end
