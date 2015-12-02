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

  describe command('curl localhost/ui/') do
    its(:stdout) { should match /<title>Consul by HashiCorp<\/title>/ }
  end
end