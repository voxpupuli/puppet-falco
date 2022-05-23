# frozen_string_literal: true

require 'spec_helper'

describe 'falco' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_class('falco').
            with_rules_file([
                              '/etc/falco/falco_rules.yaml',
                              '/etc/falco/falco_rules.local.yaml',
                              '/etc/falco/k8s_audit_rules.yaml',
                              '/etc/falco/rules.d'
                            ])
        }

        it { is_expected.to contain_class('falco::repo') }

        case facts[:os]['family']
        when 'Debian'
          it { is_expected.to contain_apt__source('falco') }
          it { is_expected.to contain_package("linux-headers-#{facts[:kernelrelease]}") }
        when 'RedHat'
          it { is_expected.to contain_class('epel') }
          it { is_expected.to contain_yumrepo('falco') }
          it { is_expected.to contain_package("kernel-devel-#{facts[:kernelrelease]}") }
        end

        it { is_expected.to contain_class('falco::install') }
        it { is_expected.to contain_package('falco') }

        it { is_expected.to contain_class('falco::config') }

        it {
          is_expected.to contain_file('/etc/falco/falco.yaml').
            with_content(%r{rules_file:\n  - /etc/falco/falco_rules.yaml\n})
        }

        it { is_expected.to contain_class('falco::service') }
        it { is_expected.to contain_service('falco') }
      end
    end
  end
end
