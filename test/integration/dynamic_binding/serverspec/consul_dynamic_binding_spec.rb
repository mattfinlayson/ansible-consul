require 'spec_helper'

describe 'Consul' do 
  describe file('/etc/consul.conf') do
    it { should be_file }
    its(:content) { should_not match /"bind_addr":/ }
  end

  describe file('/etc/init/consul.conf') do
    it { should be_file }
    its(:content) { should match /BIND=`ifconfig eth0 | grep "inet addr" | awk '{ print substr($2,6) }'`/ }
    its(:content) { should match /-bind=\$BIND \\/ }
  end
end