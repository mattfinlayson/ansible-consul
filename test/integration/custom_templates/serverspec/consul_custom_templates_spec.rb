require 'spec_helper'

describe 'Consul' do

  if ['debian', 'ubuntu'].include?(os[:family])
    describe 'custom Upstart service' do
      describe file('/etc/init/consul.conf') do
        it { should be_file }
        its(:content) { should match /\/etc\/service\/consul/}
        its(:content) { should match /BIND=`ifconfig eth0 | grep "inet addr" | awk '{ print substr($2,6) }'`/ }
        its(:content) { should match /-bind=\$BIND \\/ }
      end
    end
  end

  if os[:family] == 'redhat' and os[:release] == '7'
    describe 'custom SystemD service' do
      describe file('/etc/systemd/system/consul.service') do
        it { should be_file }
        its(:content) { should match /FOO=bar/ }
      end
    end
  end
  if os[:family] == 'redhat' and os[:release] == '6'
    describe 'custom initd service' do
      describe file('/etc/init.d/consul') do
        it { should be_file }
        its(:content) { should match /FOO=bar/ }
      end
    end
  end
end
