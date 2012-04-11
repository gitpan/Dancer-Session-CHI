package Dancer::Session::CHI;

use strict;
use warnings;
use utf8;
use Carp;
use CHI;
use Dancer::Logger;
use Dancer::ModuleLoader;
use Dancer::Config "setting";
use File::Spec::Functions qw(rel2abs);

use base "Dancer::Session::Abstract";

our $VERSION = 'v0.1.2'; # VERSION
# ABSTRACT: CHI-based session engine for Dancer

# Class methods:

my $chi;

sub create {
	my ($class) = @_;
	my $self = $class->new;
	$self->flush;
	my $session_id = $self->id;
	Dancer::Logger::debug("Session (id: $session_id) created.");
	return $self }

sub retrieve {
	my (undef, $session_id) = @_;
	$chi ||= _build_chi();
	return $chi->get($session_id) }

# Object methods:

sub flush {
	my ($self) = @_;
	$chi ||= _build_chi();
	my $session_key = "dancer_session_" . $self->id;
	$chi->set( $session_key => $self );
	return }

sub destroy {
	my ($self) = @_;
	my $session_id = $self->id;
	my $session_key = "dancer_session_session_id";
	$chi->remove($session_key);
	Dancer::Logger::debug("Session (id: $session_id) destroyed.");
	return $self }

sub reset :method {
	my ($self) = @_;
	$chi->clear;
	return $self }

sub _build_chi {
	my $options = setting("session_CHI");
	( ref $options eq ref {} ) or croak "CHI session options not found";

	# Don't let CHI determine the absolute path:
	exists $options->{root_dir}
		and $options->{root_dir} = rel2abs($options->{root_dir});

	my $use_plugin = delete $options->{use_plugin};
	my $is_loaded = exists setting("plugins")->{"Cache::CHI"};
	( $use_plugin && !$is_loaded )
		and croak "CHI plugin requested but not loaded";

	return $use_plugin
		? do {
			require Dancer::Plugin::Cache::CHI;
			Dancer::Plugin::Cache::CHI::cache() }
		: CHI->new( %{$options} ) }

1;
=encoding utf8

=head1 NAME

Dancer::Session::CHI - CHI-based session engine for Dancer

=head1 SYNOPSIS

In a L<Dancer> application:

	set session          => "CHI";
	set session_expires  => "1 hour";
	set session_CHI      => { use_plugin => 1 };

	set plugins          => {
		"Cache::CHI" => {
			driver => 'Memory',
			global => 1
		}
	};

In a F<config.yml>:

	session: CHI
	session_expires: 1 hour
	session_CHI:
		use_plugin: 1

	plugins:
		Cache::CHI:
			driver: Memory
			global: 1

=head1 DESCRIPTION

This module leverages L<CHI> to provide session management for L<Dancer>
applications. Just as L<Dancer::Session::KiokuDB> opens up L<KiokuDB>'s
full range of C<KiokuDB::Backend>::* modules to be used in Dancer session
management, L<Dancer::Session::CHI> makes available the complete
C<CHI::Driver>::* collection.

=head1 CONFIGURATION

Under its C<session_CHI> key, Dancer::Session::CHI accepts a C<use_plugin>
option that defaults to C<0>. If set to C<1>, L<Dancer::Plugin::Cache::CHI>
will be used directly for session management, with no changes made to the
plugin's configuration.

If C<use_plugin> is left false, all other options are passed through to
construct a new L<CHI> object, even if L<Dancer::Plugin::Cache::CHI> is also in
use. This new object needn't use the same L<CHI::Driver> as the plugin.

=head1 METHODS

=for Pod::Coverage BUILD

=head2 CLASS

=over

=item C<create()>

Creates a new session object and returns it.

=item C<retrieve($id)>

Returns the session object containing an ID of $id.

=back

=head2 OBJECT

=over

=item C<flush()>

Writes all session data to the CHI storage backend.

=item C<destroy()>

Ends a Dancer session and wipes all session data from the CHI storage backend.

=item C<reset()>

Clear all Dancer session data from the CHI backend.

=back

=head1 CAVEATS

=over

=item *

Some L<CHI::Driver> parameters are sufficiently complex to not be placeable in a F<config.yml>. Session and/or
plugin configuration may instead be needed to be done in application code.

=item *

When using L<CHI::Driver::DBI>, thread/fork safety can be ensured by passing it a L<DBIx::Connector> object.

=back

=head1 BUGS

This is an initial I<TRIAL> release, so bugs may be lurking. Please report any issues to this module's
L<GitHub issues page|https://github.com/rsimoes/Dancer-Session-CHI/issues>.

=head1 AUTHOR

Richard Simões <rsimoes at CPAN dot org>

=head1 COPYRIGHT AND LICENSE

Copyright © 2011 Richard Simões. This module is released under the terms of the
L<Artistic License 2.0|http://www.perlfoundation.org/artistic_license_2_0>
and may be modified and/or redistributed under the same or any compatible license.
