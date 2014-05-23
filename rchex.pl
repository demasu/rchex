#!/usr/bin/perl

use strict;
use warnings;

my $ruby_req_path      = '/usr/bin/ruby';
my $ruby_found_path    = `which ruby`;
my $ruby_req_target    = '1.8.7-p374';
my $gem_req_path       = '/usr/bin/gem';
my $gem_found_path     = `which gem`;
my $gem_req_target     = '1.8.25';
my $rails_req_path     = '/usr/bin/rails';
my $rails_found_path   = `which rails`;
my $rails_req_target   = 'rails (2.3.18)';
my $mongrel_req_path   = '/usr/lib/ruby/gems/1.8/gems/mongrel-1.1.5';
my $mongrel_req_target = 'mongrel (1.1.5)';

# Find the current binary Ruby is using, and compare it to what we want.
chomp($ruby_found_path);
if ($ruby_found_path eq $ruby_req_path) {
    print "[Okay] - Ruby binary looks good.\n";

    # We need to ensure this version is installed: 1.8.7-p374
    chomp(my $ruby_version = `$ruby_req_path -e'puts "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"'`);
    if ($ruby_version eq $ruby_req_target) {
        print "[Okay] - Ruby version matches target version: $ruby_version\n";
    } else {
        die("[Fatal] - Ruby version not at target: $ruby_version installed, $ruby_req_target expected\n");
    }
} else {
    print "[Warning] - Installed Ruby may not be the one cPanel installs; keep an eye out.\n";
}

# Find the current binary RubyGems is using, and compare it to what we want.
chomp($gem_found_path);
if ($gem_found_path eq $gem_req_path) {
    print "[Okay] - RubyGems binary looks good\n";
    
    # We need to ensure this version is installed: 1.8.25
    chomp(my $gem_version = `$gem_req_path -v`);
    if ($gem_version eq $gem_req_target) {
        print "[Okay] - RubyGems version matches target version: $gem_version\n";
    } else {
        die("[Fatal] - RubyGems version not at target: $gem_version installed, $gem_req_target expected\n");
    }
} else {
    print "[Warning] - Installed RubyGems may not be the one cPanel installs; keep an eye out.\n";
}

# Find the current binary Rails is using, and compare it to what we want.
chomp($rails_found_path);
if ($rails_found_path eq $rails_req_path) {
    print "[Okay] - Rails binary looks good\n";

    # We need to ensure this version is installed: 2.3.18
    chomp(my $rails_version = `gem list rails|grep ^rails`);
    if ($rails_version eq $rails_req_target) {
        print "[Okay] - Rails version matches target version: $rails_version\n";
    } else {
        # I'll get around to splitting this and working with expect, but for now this works.
        die("[Fatal] - String match verification failed - Rails version not at target: $rails_version installed, $rails_req_target expected\n");
    }
} else {
    print "[Warning] - Installed Rails may not be the one cPanel installs; keep an eye out.\n";
}

if (-d $mongrel_req_path) {
    print "[Okay] - Mongrel library present\n";

    # We need to ensure this version is installed: 1.1.5
    chomp(my $mongrel_version = `gem list mongrel|grep ^mongrel`);
    if ($mongrel_version eq $mongrel_req_target) {
        print "[Okay] - Mongrel version matches target version: $mongrel_req_target\n";
    } else {
        die("[Fatal] - String match verification failed - Mongrel version not at target: $mongrel_version installed, $mongrel_req_target expected\n");
    }
} else {
    die("[Fatal] - Can't find Mongrel\n");
}
