
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Dancer" => 0,
    "Dancer::Test" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "Module::Build" => "0.3601",
    "Test::More" => 0,
    "Test::Most" => "0.22",
    "perl" => "5.006",
    "strict" => 0,
    "warnings" => 0
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "CHI-based session engine for Dancer",
  "dist_author" => [
    "Richard Sim\303\265es <rsimoes at cpan dot org>"
  ],
  "dist_name" => "Dancer-Session-CHI",
  "dist_version" => "v0.1.1",
  "license" => "lgpl",
  "module_name" => "Dancer::Session::CHI",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "CHI" => "0.49",
    "Dancer::Config" => 0,
    "Dancer::Logger" => 0,
    "Dancer::Plugin::Cache::CHI" => 0,
    "Dancer::Session::Abstract" => 0,
    "English" => 0,
    "Moose" => "2.0205",
    "MooseX::ClassAttribute" => "0.26",
    "MooseX::NonMoose" => "0.22",
    "namespace::autoclean" => "0.13",
    "perl" => "5.008",
    "strictures" => 1,
    "utf8" => 0
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
