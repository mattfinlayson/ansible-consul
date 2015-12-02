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

  describe file('/etc/consul.conf') do
    it { should be_file }
    its(:content) { should match /"server": true/ }
  end

  if ['debian', 'ubuntu'].include?(os[:family])
    describe file('/etc/init/consul.conf') do
      it { should be_file }
      its(:content) { should match /GOMAXPROCS=`nproc`/ }
    end

    describe file('/var/log/consul') do
      it { should be_file }
    end
  end
end