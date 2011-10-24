package Dancer::Session::CHI;

use v5.10;
use strict;
use warnings;
use utf8::all;
use namespace::autoclean 0.13;
use CHI 0.49;
use Dancer::Config ();
use Dancer::Logger ();
use English '-no_match_vars';
use Moose 2.0205;
use MooseX::ClassAttribute 0.26;
use MooseX::NonMoose 0.22;
use MooseX::InsideOut 0.106;
use MooseX::Types::Moose 0.30 'HashRef';
use Scalar::Util 'blessed';

extends 'Dancer::Session::Abstract';

our $VERSION = 'v0.0.2'; # VERSION
# ABSTRACT: CHI-based session engine for Dancer

class_has _cache => (
	is         => 'ro',
	isa        => 'Object',
	lazy_build => 1
);

my $class = __PACKAGE__;
sub _config;

# Class methods:

sub create {
	# Indirectly create new session by flushing:
	my $self = $class->new;
	$self->flush;
	return $self;
};

sub retrieve {
	my ($class, $session_id) = @ARG;
	my $session = $class->_cache->get( 'dancer_session_' . $session_id );
	return $session;
}

# Object methods:

sub flush {
	my ($self) = @ARG;
	my $session_key = 'dancer_session_' . $self->id;
	$class->_cache->set( $session_key => $self );
	_debug("Session data written to $session_key.");
	return;
}

sub destroy {
	my ($self) = @ARG;
	my $session_key = 'dancer_session_' . $self->id;
	$class->_cache->remove($session_key);
	_debug("Session $session_key destroyed.");
	return;
}

# Utility functions:

sub _debug {
	my ($msg) = @ARG;
	return Dancer::Logger::debug($msg);
}

sub _config {
	my ($key) = @ARG;
	return Dancer::Config::settings($key);
}

# Attribute builders:

sub _build__cache {
	my $options = _config->{session_CHI};
	confess 'CHI session options not found' if not ref $options;
	my $use_plugin = $options->{use_plugin} ? 1 : 0;
	my $is_loaded = exists _config->{plugins}{'Cache::CHI'};

	confess "CHI plugin requested but not loaded" if $use_plugin and not $is_loaded;
	if ($use_plugin) {
		require Dancer::Plugin::Cache::CHI;
		Dancer::Plugin::Cache::CHI->import;
		return cache();
	} else {
		my %options = %$options;
		delete $options{use_plugin};
		return CHI->new(\%options);
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
