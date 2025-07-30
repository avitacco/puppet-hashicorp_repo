# frozen_string_literal: true

require 'spec_helper'

describe 'hashicorp_repo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      case os_facts[:os]['family']
      when 'Debian'
        context 'on Debian-based systems' do
          it 'creates the HashiCorp apt source' do
            is_expected.to contain_apt__source('hashicorp').with(
              'comment'      => 'Official HashiCorp package repository',
              'location'     => 'https://apt.releases.hashicorp.com',
              'release'      => os_facts[:os]['distro']['codename'],
              'repos'        => 'main',
              'key'          => {
                'name'   => 'hashicorp.gpg',
                'source' => 'https://apt.releases.hashicorp.com/gpg',
              },
            )
          end

          context 'with aarch64 architecture' do
            let(:facts) do
              os_facts.merge(
                {
                  'os' => os_facts[:os].merge(
                    {
                      'architecture' => 'aarch64'
                    },
                  )
                },
              )
            end

            it 'maps aarch64 to arm64 architecture' do
              is_expected.to contain_apt__source('hashicorp').with_architecture('arm64')
            end
          end

          context 'with x86_64 architecture' do
            let(:facts) do
              os_facts.merge(
                {
                  'os' => os_facts[:os].merge(
                    {
                      'architecture' => 'x86_64'
                    },
                  )
                },
              )
            end

            it 'uses x86_64 architecture as-is' do
              is_expected.to contain_apt__source('hashicorp').with_architecture('x86_64')
            end
          end
        end

      when 'RedHat'
        context 'on RedHat-based systems' do
          it 'does not create any repository resources (TODO: not implemented)' do
            is_expected.not_to contain_yumrepo('hashicorp')
            is_expected.not_to contain_apt__source('hashicorp')
          end
        end

      else
        context 'on unsupported systems' do
          it 'fails with an appropriate error message' do
            is_expected.to compile.and_raise_error(
              %r{This module \(hashicorp_repo\) only supports Debian and RedHat-based distributions},
            )
          end
        end
      end
    end
  end

  context 'with custom facts for unsupported OS family' do
    let(:facts) do
      {
        'os' => {
          'family' => 'Solaris',
          'name' => 'Solaris',
          'architecture' => 'x86_64'
        }
      }
    end

    it 'fails compilation with appropriate error message' do
      is_expected.to compile.and_raise_error(
        %r{This module \(hashicorp_repo\) only supports Debian and RedHat-based distributions},
      )
    end
  end
end
