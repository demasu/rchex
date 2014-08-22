#!/usr/bin/perl

use strict;
use warnings;
use Carp;
use Getopt::Long;

package main;

main() unless caller;

sub main {
    my $help = '';

    GetOptions( 'help|h' => \$help );

    help() if $help;

    initialize();
}

sub initialize {
    # This portion launches and controlls function loads
    ruby_installed_check();
    ruby_version_checks();
    gem_checks();
    gem_version_checks();
    rails_checks();
    rails_version_checks();
    mongrel_checks();
    mongrel_version_checks();
    
    # For right now, this is useless, but I will add more to it later.
}

sub ruby_installed_check {
    # Find the current binary Ruby is using, and compare it to what we want.
    my $ruby_req_path           = '/usr/bin/ruby';
    chomp( my $ruby_found_path  = `which ruby 2>/dev/null` );

    if ($ruby_found_path eq $ruby_req_path) {
        print status_message("ok", "Expected Ruby binary exists: $ruby_req_path");
    } else {
        print status_message("warn", "Ruby found, but likely not from cPanel");
    }
    # Since Ruby was found, we can continue, but warning has been presented.
}

sub ruby_version_checks {
    # We need to ensure this version is installed: 1.8.7-p374
    chomp(my $ruby_version  = `ruby -e'puts "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"'`);
    
    if ($ruby_version eq $ruby_req_target) {
        print status_message("ok", "Expected Ruby version found: $ruby_version");
    } else {
        croak status_message("fatal", "Ruby version not at target: $ruby_version installed, $ruby_req_target expected");
        # Let's die here, since a bad Ruby version can mess with Rails compatibility, among other things.
    }
}

sub gem_checks {
    # Find the current binary RubyGems is using, and compare it to what we want.
    my $gem_req_path                = '/usr/bin/gem';
    chomp( my $gem_found_path       = `which gem 2> /dev/null` );

    if ($gem_found_path eq $gem_req_path) {
        print status_message("ok", "RubyGems binary looks good");
    } else {
        print status_message("warn", "Installed RubyGems may not be the one cPanel installs; keep an eye out.");
    }
}

sub gem_version_checks {
    # We need to ensure this version is installed: 1.8.25
    my $gem_req_target      = '1.8.25';
    chomp(my $gem_version   = `gem -v`);
    
    if ($gem_version eq $gem_req_target) {
        print status_message("ok", "Expected RubyGems version found");
    } elsif ( $gem_version eq "2.3.0" ) {
        print status_message("warn", "RubyGems 2.3.0 found.\n\tIs there an issue with fetching modules in cPanel under \"Ruby Gems -> Show System Installed Modules\"? Check case #111553");
    } else {
        croak status_message("fatal", "RubyGems version not at target: $gem_version installed, $gem_req_target expected");
        # Let's die here, since a bad RubyGems version can mess with Rails compatibility, among other things.
    }
}

sub rails_checks {
    # Find the current binary Rails is using, and compare it to what we want.
    my $rails_req_path              = '/usr/bin/rails';
    chomp( my $rails_found_path     = `which rails 2> /dev/null` );

    if ($rails_found_path eq $rails_req_path) {
        print status_message("ok", "Expected Rails binary found");
    } else {
        print status_message("warn", "Installed Rails may not be the one cPanel installs; keep an eye out.");
    }
}

sub rails_version_checks {
    # We need to ensure this version is installed: 2.3.18
    my $rails_req_target            = 'rails (2.3.18)';
    chomp(my $rails_version = `gem list rails|grep ^rails`);
    
    if ($rails_version eq $rails_req_target) {
        print status_message("ok", "Expected Rails version installed");
    } else {
        # I'll get around to splitting this and working with expect, but for now this works.
        croak status_message("fatal", "String match verification failed - Rails version not at target: $rails_version installed, $rails_req_target expected");
        # Let's die here, since a bad Rails version can mess with Rails compatibility, among other things.
    }
}

sub mongrel_checks {
    my $mongrel_req_path   = '/usr/lib/ruby/gems/1.8/gems/mongrel-1.1.5';

    if (-d $mongrel_req_path) {
        print status_message("ok", "Expected Mongrel library present");
    } else {
        croak status_message("fatal", "Can't find Mongrel library");
        # Let's die here, since we need mongrel for cPanel to do anything Rails related.
    }
}

sub mongrel_version_checks {
    # We need to ensure this version is installed: 1.1.5
    my $mongrel_req_target      = 'mongrel (1.1.5)';
    chomp(my $mongrel_version   = `gem list mongrel|grep ^mongrel`);

    if ($mongrel_version eq $mongrel_req_target) {
        print status_message("ok", "Expected Mongrel version found");
    } else {
        croak status_message("fatal", "String match verification failed - Mongrel version not at target: $mongrel_version installed, $mongrel_req_target expected");
        # Let's die here, since a bad Mongrel version can mess with Rails compatibility, among other things.
    }
}

sub status_message {
    my ($type, $message) = @_;
    my $errlvl;
    $message ||= "Something bad happened";

    if ( $type =~ /warn/i ) {
        $errlvl = "[Warning]";
    } elsif ( $type =~ /fatal/i ) {
        $errlvl = "[Fatal]";
    } elsif ( $type =~ /ok/i ) {
        $errlvl = "[Okay]";
    } else {
        $errlvl = "[Unknown]";
    }
    
    return "$errlvl - $message\n";
}

sub help {
    print "
Script Name: $0
Status:      Beta
Maintainer:  Ryan Sherer
Script home: https://github.com/polloparatodos/rchex\n
\t--help       print this message and exit
";
    exit 1;
}
