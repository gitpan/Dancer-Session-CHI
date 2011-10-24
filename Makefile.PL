
use strict;
use warnings;

use 5.010000;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "CHI-based session engine for Dancer",
  "AUTHOR" => "Richard Sim\303\265es <rsimoes at cpan dot org>",
  "BUILD_REQUIRES" => {
    "Carp::Always" => "0.10",
    "Dancer" => 0,
    "Dancer::Test" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "Test::More" => 0,
    "Test::Most" => "0.22"
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
    "Dancer::Config" => 0,
    "Dancer::Logger" => 0,
    "Dancer::Plugin::Cache::CHI" => 0,
    "Dancer::Session::Abstract" => 0,
    "English" => 0,
    "Moose" => "2.0205",
    "MooseX::ClassAttribute" => "0.26",
    "MooseX::InsideOut" => "0.106",
    "MooseX::NonMoose" => "0.22",
    "MooseX::Types::Moose" => "0.30",
    "Scalar::Util" => 0,
    "namespace::autoclean" => "0.13",
    "strict" => 0,
    "utf8::all" => 0,
    "warnings" => 0
  },
  "VERSION" => "v0.0.2",
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



