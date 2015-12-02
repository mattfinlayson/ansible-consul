require 'spec_helper'

describe 'Consul' do
  describe service('consul') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  if ['debian', 'ubuntu'].include?(os[:family])
    describe file('/etc/nginx/sites-enabled/consul') do
      it { should be_file }
      its(:content) { should match /proxy_pass http:\/\/\$server_addr:1234;/ }
    end
  end

  describe command('curl localhost/ui/') do
    its(:stdout) { should match /<title>Consul by HashiCorp<\/title>/ }
  end
end