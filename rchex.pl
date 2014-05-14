#!/usr/bin/perl

use strict;
use warnings;

my $ruby_path    = '/usr/bin/ruby';
my $ruby_target  = '1.8.7-p374';
my $gem_path     = '/usr/bin/gem';
my $gem_target   = '1.8.25';
my $rails_path   = '/usr/local/bin/rails';
my $rails_target = 'rails (2.3.18)';

if (-e $ruby_path) {
    print "[Okay] - Ruby exists\n";

    # We need to ensure this version is installed: 1.8.7-p374
    chomp(my $ruby_version = `ruby -e'puts "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"'`);
    if ($ruby_version eq $ruby_target) {
        print "[Okay] - Ruby version matches target version: $ruby_version\n";
    } else {
        die("[Fatal] - Ruby version not at target: $ruby_version installed, $ruby_target expected\n");
    }
} else {
    die("[Fatal] - Can't find Ruby\n");
}

if (-e $gem_path) {
    print "[Okay] - RubyGems exists\n";
    
    # We need to ensure this version is installed: 1.8.25
    chomp(my $gem_version = `$gem_path -v`);
    if ($gem_version eq $gem_target) {
        print "[Okay] - Gem version matches target version: $gem_version\n";
    } else {
        die("[Fatal] - Gem version not at target: $gem_version installed, $gem_target expected\n");
    }
} else {
    die("[Fatal] - Can't find RubyGems\n");
}

if (-e $rails_path) {
    print "[Okay] - Rails found\n";

    # We need to ensure this version is installed: 2.3.18
    chomp(my $rails_version = `gem list rails|grep ^rails`);
    if ($rails_version eq $rails_target) {
        print "[Okay] - Rails version matches target version: $rails_version\n";
    } else {
        # I'll get around to splitting this and working with expect, but for now this works.
        die("[Fatal] - String match verification failed - Rails version not at target: $rails_version installed, $rails_target expected\n");
    }
} else {
    die("[Fatal] - Can't find Rails\n");
}
