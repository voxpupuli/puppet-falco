# frozen_string_literal: true

require 'spec_helper'

describe 'falco::config' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with file_output defined' do
        let(:hiera_data) do
          {
            'falco::file_output' => {
              'enabled' => true,
              'keep_alive' => false,
              'filename' => '/var/log/falco-events.log'
            }
          }
        end

        it { is_expected.to contain_logrotate__rule('falco_output') }
      end
    end
  end
end
