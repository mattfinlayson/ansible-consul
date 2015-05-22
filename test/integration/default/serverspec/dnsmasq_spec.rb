require 'spec_helper'

describe 'dnsmasq' do
  describe service('dnsmasq') do
    it { should be_enabled }
    it { should be_running }
  end
end