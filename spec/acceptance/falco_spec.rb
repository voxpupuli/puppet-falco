# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'falco' do
  # falco cant load eBPF probes in a container so keep it stopped
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<~PUPPET
        class { 'falco':
          driver         => 'modern-bpf',
          service_ensure => 'stopped',
          service_enable => false,
          local_rules    => [
            {
              'macro'     => 'acceptance_test',
              'condition' => 'proc.name = acceptance',
            },
          ],
        }
      PUPPET
    end
  end

  describe package('falco') do
    it { is_expected.to be_installed }
  end

  describe file('/etc/falco/falco.yaml') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to match %r{/etc/falco/falco_rules.local.yaml} }
  end

  describe file('/etc/falco/falco_rules.local.yaml') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to match %r{macro: acceptance_test} }
  end

  describe service('falco-modern-bpf') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end
end
