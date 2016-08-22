require 'spec_helper'
describe 'consul_watch' do
  context 'with default values for all parameters' do
    it { should contain_class('consul_watch') }
  end
end
