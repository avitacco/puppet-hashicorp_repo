# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'init class' do
  context 'applying hashicorp_repo class works' do
    let(:pp) do
      <<-CODE
        include hashicorp_repo
      CODE
    end

    it 'behaves idempotently' do
      idempotent_apply(pp)
    end

    if os[:family] == 'redhat'

      # Ensure the yum repo exists and is enabled
      describe yumrepo('hashicorp') do
        it {
          is_expected.to exist
          is_expected.to be_enabled
        }
      end

      describe command('yum -y info nomad') do
        its(:stdout) { is_expected.to match(%r{Repository\s+: hashicorp}) }
      end
    elsif ['debian', 'ubuntu'].include?(os[:family])

      # Ensure the repo exists on the filesystem
      describe file('/etc/apt/sources.list.d/hashicorp.list') do
        it { is_expected.to be_file }
        its(:content) { is_expected.to match(%r{https://apt.releases.hashicorp.com}) }
      end

      describe command('apt-cache show nomad=1.10.0-1') do
        its(:exit_status) { is_expected.to eq 0 }
        its(:stdout) { is_expected.to match(%r{Maintainer: HashiCorp}) }
      end
    end
  end

  context 'removing hashicorp repo class works' do
    let(:pp) do
      <<-CODE
        class { 'hashicorp_repo':
          ensure => absent,
        }
      CODE
    end

    it 'behaves idempotently' do
      idempotent_apply(pp)
    end

    if os[:family] == 'redhat'
      describe yumrepo('hashicorp') do
        it {
          is_expected.not_to exist
          is_expected.not_to be_enabled
        }
      end
    elsif ['debian', 'ubuntu'].include?(os[:family])
      describe file('/etc/apt/sources.list.d/hashicorp.list') do
        it {
          is_expected.not_to be_file
        }
      end
    end
  end
end
