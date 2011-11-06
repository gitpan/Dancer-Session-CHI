
use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "CHI-based session engine for Dancer",
  "AUTHOR" => "Richard Sim\303\265es <rsimoes at cpan dot org>",
  "BUILD_REQUIRES" => {
    "Carp::Always" => "0.10",
    "Dancer::Test" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "Test::More" => 0,
    "Test::Most" => "0.22",
    "strict" => 0,
    "warnings" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Dancer-Session-CHI",
  "EXE_FILES" => [],
  "LICENSE" => "artistic_2",
  "NAME" => "Dancer::Session::CHI",
  "PREREQ_PM" => {
    "CHI" => "0.49",
    "Dancer" => "1.3072",
    "Dancer::Plugin::Cache::CHI" => 0,
    "Dancer::Session::Abstract" => 0,
    "English" => 0,
    "Moose" => "2.0205",
    "MooseX::ClassAttribute" => "0.26",
    "MooseX::NonMoose" => "0.22",
    "Scalar::Util" => 0,
    "namespace::autoclean" => "0.13",
    "strictures" => 1,
    "utf8" => 0
  },
  "VERSION" => "v0.0.4",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



