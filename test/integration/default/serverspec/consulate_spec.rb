require 'spec_helper'

describe 'Consulate' do
  describe file('/usr/local/bin/consulate') do
    it { should_not be_file }
  end
end