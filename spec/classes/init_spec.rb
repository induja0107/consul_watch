require 'spec_helper'
describe 'consul_watch' do
  context 'with default values for all parameters' do
    it { should contain_class('consul_watch') }
    it { should compile}
    it do
         should contain_file('/opt/continuous_delivery/bin/my-key-handler.sh').with(
           :mode   => '0755',
           :owner  => 'root',
           :group  => 'root',)
      end
      it do
         should contain_file('/opt/continuous_delivery/bin/consulwatch.sh').with(
           :mode    => '0755',
           :owner   => 'root',
           :group   => 'root',)
       end
       it do
         should contain_service('consulwatch').with(
           :'ensure'     => 'running',
           :'provider'   => 'base',
           :'start'      => '/opt/continuous_delivery/bin/consulwatch.sh',
           :'pattern'    => 'consul watch',
           :'hasstatus'  => 'true',
           :'hasrestart' => 'true',)
        end
    end
end
