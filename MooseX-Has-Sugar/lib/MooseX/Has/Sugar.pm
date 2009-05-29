package MooseX::Has::Sugar;

use warnings;
use strict;

our $VERSION = '0.0300';

use Carp            ();
use List::MoreUtils ();
use Sub::Exporter   ();

Sub::Exporter::setup_exporter(
    {
        as      => 'do_import',
        exports => [
            'ro',         'rw',     'required', 'lazy',
            'lazy_build', 'coerce', 'weak_ref', 'auto_deref',
        ],
        groups => {
            isattrs => [ 'ro', 'rw', ],
            attrs   => [
                'required', 'lazy', 'lazy_build', 'coerce',
                'weak_ref', 'auto_deref',
            ],
            allattrs => [ '-attrs', '-isattrs' ],
            default => [ '-attrs', '-isattrs' ],
        }
    }
);

sub import {
    for (@_) {
        if ( $_ =~ qr/^[:-]is$/ ) {
            Carp::croak( "Trivial ro/rw with :is dropped as of 0.0300.\n"
                  . " See MooseX::Has::Sugar::Minimal for those. " );
        }
    }
    goto &MooseX::Has::Sugar::do_import;
}

sub ro() {
    return ( 'is', 'ro' );
}

sub rw() {
    return ( 'is', 'rw' );
}

sub required() {
    return ( 'required', 1 );
}

sub lazy() {
    return ( 'lazy', 1 );
}

sub lazy_build() {
    return ( 'lazy_build', 1 );
}

sub weak_ref() {
    return ( 'weak_ref', 1 );
}

sub coerce() {
    return ( 'coerce', 1 );
}

sub auto_deref() {
    return ( 'auto_deref', 1 );
}
1;

__END__

=head1 NAME

MooseX::Has::Sugar - Sugar Syntax for moose 'has' fields.

=head1 VERSION

Version 0.0300

=head1 SYNOPSIS

L<Moose> C<has> syntax is generally fine, but sometimes one gets bothered with
the constant typing of string quotes for things. L<MooseX::Types> exists and in
many ways reduces the need for constant string creation.

Strings are a bit problematic though, due to whitespace etc, and you're not
likely to get compile time warnings if you do them wrong.

The constant need to type C<=E<gt>> and C<''> is fine for one-off cases, but
the instant you have more than about 4 attributes it starts to get annoying.

The only problem I see with the approach given by this module is the potential
of an extra level of indirection. But its a far lesser evil in my mind than
the alternative.

=head2 Before this Module.

=head3 Classical Moose

    has foo => (
            isa => 'Str',
            is  => 'ro',
            required => 1,
    );

    has bar => (
            isa => 'Str',
            is => 'rw'
            lazy_build => 1,
    );

=head3 Lazy Evil way to do it:

B<PLEASE DONT DO THIS>

    has qw( foo isa Str is ro required 1 );
    has qw( bar isa Str is rw lazy_build 1 );

=head2 With this module

( and with MooseX::Types )

    use MooseX::Types::Moose qw( Str );
    use MooseX::Has::Sugar;

    has foo => (
            isa => Str,
            ro,
            required,
    );
    has bar => (
            isa => Str,
            rw,
            lazy_build,
    );

Or even

    use MooseX::Types::Moose qw( Str );
    use MooseX::Has::Sugar;

    has foo => ( isa => Str, ro,  required, );
    has bar => ( isa => Str, rw,  lazy_build, );

=head2 Alternative Forms

=head3 Basic C<is> Expansion Only

( using L<MooseX::Has::Sugar::Minimal> instead )

    use MooseX::Types::Moose qw( Str );
    use MooseX::Has::Sugar::Minimal;

    has foo => (
            isa => Str,
            is  => ro,
            required => 1,
    );
    has bar => (
            isa => Str,
            is => rw,
            lazy_build => 1,
    );

=head3 Attribute Expansions with Basic Expansions

( Combining parts of this and L<MooseX::Has::Sugar::Minimal> )

    use MooseX::Types::Moose qw( Str );
    use MooseX::Has::Sugar::Minimal;
    use MooseX::Has::Sugar qw( :attrs );

    has foo => (
            isa => Str,
            is  => ro,
            required,
    );
    has bar => (
            isa => Str,
            is => rw,
            lazy_build,
    );


=head1 EXPORT

=over 4

=item rw

=item ro

=item lazy

=item lazy_build

=item required

=item coerce

=item weak_ref

=item auto_deref

=back

=head1 EXPORT GROUPS

=over 4

=item :default

Since 0.0300, this exports all our syntax, the same as C<:attrs :isattrs>.
Primarily because I found you generally want all the sugar, not just part of it.
This also gets rid of that nasty exclusion logic.

=item :is

B<DEPRECATED>. See L<MooseX::Has::Sugar::Minimal> for the same functionality

=item :attrs

This exports C<lazy> , C<lazy_build> and C<required>, C<coerce>, C<weak_ref>
and C<auto_deref> as subs that assume positive.

    has foo => (
            required,
            isa => 'Str',
    );

=item :isattrs

This exports C<ro> and C<rw> as lists, so they behave as stand-alone attrs like
C<lazy> does.

    has foo => (
            required,
            isa => 'Str',
            ro,
    );

B<NOTE: This option is incompatible with L<MooseX::Has::Sugar::Minimal>>

=item :allattrs

This is  a shorthand for  qw( :isattrs :attrs )

=back

=head1 FUNCTIONS

These you probably don't care about, they're all managed by L<Sub::Exporter>
and its stuff anyway.

=over 4

=item rw

returns C<('is','rw')>

=item ro

returns C<('is','ro')>

=item lazy

returns C<('lazy',1)>

=item required

returns C<('required',1)>

=item lazy_build

returns C<('lazy_build',1)>

=item coerce

returns C<('coerce',1)>

=item weak_ref

returns C<('weak_ref',1)>

=item auto_deref

returns C<('auto_deref',1)>

=back

=head1 AUTHOR

Kent Fredric, C<< <kentnl at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-moosex-has-extras at rt.cpan.org>, or through
the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Has-Sugar>.  I will be
notified, and then you'll automatically be notified of progress on your bug
as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooseX::Has::Sugar


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-Has-Sugar>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-Has-Sugar>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-Has-Sugar>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-Has-Sugar/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Kent Fredric, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

# End of MooseX::Has::Sugar
