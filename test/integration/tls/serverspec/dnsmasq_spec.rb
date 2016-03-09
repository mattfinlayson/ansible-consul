require 'spec_helper'

describe 'dnsmasq' do
  describe service('dnsmasq') do
    it { should_not be_enabled }
    it { should_not be_running }
  end
end