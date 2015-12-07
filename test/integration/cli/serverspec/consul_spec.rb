require 'spec_helper'

describe 'Consul' do
  describe service('consul') do
    it { should be_enabled }
    it { should be_running }
  end

  describe user('consul') do
    it { should exist }
    it { should belong_to_group 'consul' }
  end

  %w(/opt/consul /opt/consul/bin /opt/consul/data /etc/consul.d ).each do |dir|
    describe file(dir) do
      it { should be_directory }
      it { should be_owned_by('consul') }
    end
  end

  describe file('/opt/consul/bin/consul-cli') do
    it { should be_file }
    it { should be_owned_by('consul') }
  end

  describe command('/opt/consul/bin/consul-cli agent-self') do
    its(:exit_status) { should eq 0 }
  end
end