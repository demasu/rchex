#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;
use Test::Output;

use_ok( 'rchex' );
stdout_is( sub{ main::ruby_installed_check() }, "[Okay] - Expected Ruby binary exists: /usr/bin/ruby\n", "Installed ruby binary is in the right location" );
stdout_is( sub{ main::ruby_version_checks() }, "[Okay] - Expected Ruby version found: 1.8.7-p374\n", "Ruby version is correct" );
stdout_is( sub{ main::gem_checks() }, "[Okay] - RubyGems binary looks good\n", "Gem binary is in the right location" );
stdout_is( sub{ main::gem_version_checks() }, "[Okay] - Expected RubyGems version found\n", "Gem version is correct" );
stdout_is( sub{ main::rails_checks() }, "[Okay] - Expected Rails binary found\n", "Rails binary is in the correct location" );
stdout_is( sub{ main::rails_version_checks() }, "[Okay] - Expected Rails version installed\n", "Rails version is correct" );
stdout_is( sub{ main::mongrel_checks() }, "[Okay] - Expected Mongrel library present\n", "Mongrel is in the right location" );
stdout_is( sub{ main::mongrel_version_checks() }, "[Okay] - Expected Mongrel version found\n", "Mongrel version is correct" );

