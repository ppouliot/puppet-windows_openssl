# === Class: windows_openssl
#
# This module installs openssl on Windows systems. It also adds an entry to the
# PATH environment variable.
#
# === Parameters
#
# [*url*]
#   HTTP url where the installer is available. It defaults to main site.
# [*package*]
#   Package name in the system.
# [*file_path*]
#   This parameter is used to specify a local path for the installer. If it is
#   set, the remote download from $url is not performed. It defaults to false.
#
# === Examples
#
# class { 'windows_openssl': }
#
# class { 'windows_openssl':
#   $url     => 'http://192.168.1.1/files/openssl.exe',
#   $package => 'openssl version 1.8.0-preview201221022',
# }
#
# === Authors
# 
#
class windows_openssl (
  $url       = $::windows_openssl::params::url,
  $package   = $::windows_openssl::params::package,
  $file_path = false,
) inherits windows_openssl::params {
  
  if $file_path {
    $openssl_installer_path = $file_path
  } else {
    $openssl_installer_path = "${::temp}\\${package}.exe"
    windows_common::remote_file{'openssl':
      source      => $url,
      destination => $openssl_installer_path,
      before      => Package[$package],
    }
  }
  class { 'windows_visualcplusplus2008': }
  package { $package:
    ensure          => installed,
    source          => $openssl_installer_path,
    install_options => ['/VERYSILENT','/SUPPRESSMSGBOXES','/LOG'],
	requires        =. Class['windows_visualcplusplus2008'],
  }
  
}
