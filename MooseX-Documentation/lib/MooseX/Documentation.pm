package MooseX::Documentation;

# $Id:$
use strict;
use warnings;
use Moose                                 ();
use Carp                                  ();
use Moose::Exporter                       ();
use Moose::Util::MetaRole                 ();
use MooseX::Documentation::Role::Class    ();
use MooseX::Documentation::Strings::Class ();
use Moose::Util                           ();

our $VERSION = '0.0100';

Moose::Exporter->setup_import_methods( with_caller => ['document'], );

#
# init_meta bolts in meta->documentation ( MooseX::Documention::Package )
#
sub init_meta
{
    shift;
    my %options = @_;
    Moose->init_meta(%options);

    return Moose::Util::MetaRole::apply_metaclass_roles(
        for_class       => $options{for_class},
        metaclass_roles => ['MooseX::Documentation::Role::Class'],
    );

}

sub check_install
{
    my $package = shift;
    my $meta    = Class::MOP::Class->initialize($package);
    return $meta->documentation;
}

# TODO Use ourself to document ourself. This might be a joke.
sub document
{
    my ( $caller, $name, %options ) = @_;
    check_install($caller)->strings->add_method(
        name    => $name,
        options => \%options
    );
}
1;
__END__

=head1 NAME

MooseX::Documentation - Documentation for Moose classes In Moose

=head1 VERSION

0.0100

=head1 SYNOPSIS

    package Foo;
    use Moose;
    use MooseX::Documentation;

    document 'my_method' => (
            brief => qq{
                My Method is a great method and does great things.
                Please give me all your moneys because it is so great.
            },
    );
    sub my_method {
        /* teh codez */
    }

    package main;
    use Foo;

    # Get all documentation we have on hand for Foo
    print Foo->meta->documentation->to_pod;

    # Get all documentation we have on hand for 'my_method'
    print Foo->meta->documentation->method('my_method')->to_pod;


=head1 DESCRIPTION

The current primary goal of this module is to store data.

It presently does Podificatoin, but that is not the intent.

This module is simply to provide a syntax to the user to provide documentation that is :

=over 4

=item 1. Readable ( Both in code, and in wherever its rendered )

=item 2. Created Programmatically

=item 3. Accessible Programmatically.

=back

Podification is just there for Proof Of Concept purposes.

There will likely be better tools that harvest metadata in future to get nice pretty pod, and this
module is just existing so that when those tools come into existance there will be something for them to read.

=head1 GOALS

Maybe, one day, this generic ->documentation interface will provide meta-data to you about attributes,
classes, inheritance, and other fun stuff.

We'd like to be able to inspect method signatures ( if present ) defined with MooseX::Method::Signatures
and stuff them in automatically.

We'd like to be able to carp/croak when methods are undocumented, or the documentation is for a non-existing method.

If you can realise these, patches welcome.

=head1 METHODS

=head2 document $METHODNAME => ( %PARAMS )

Creates a document record for the method $METHODNAME.

=head3 Behaviour.

=over 4

=item 1. Does not check to see if method actually exists ( TODO )

=item 2. Does not complain about methods that do exist not being documented ( TODO )

=item 3. Presently Assumes you are determining meta-data that can be used for documentation for a method.  May be extended later.

=back

=head3 Data.

At present, does not care about your parameters if it doesn't recognise them.
Unrecognised Parameters will be stashed on the 'miscelaneous' node of a method.

All sections content are subject to the sterlisation process to make it easier to consume
by 3rd party code.

=over 4

=item 1. Value strings will be trimmed of leading/tailing whitespace of all kinds.

=item 2. Value strings containing \n delimiters will be split and stored internally
as an array. This is to make anything that emits your documentation such as C<L<Data::Dumper>> print nicer data.

=back

=head3 Currently Recognised Attributes

=over 4

=item brief

=over 6

=item * Required.

=item * Example:

    document foo => ( brief => qq{ Hello world } );

=item * Example:

    document foo => ( brief => [ 'Hello world' , 'Multiline data' ] );

=item * Example:
( The same as above )

    document foo => ( brief => qq{Hello world\nMultiline data} );

=back

This field is a required parameter for giving a brief explaination, or a verbose one,
for explaining what the documented method does.

=back

=head1 META Methods.

Packages that use this class will have extra stuff visible on thier meta.

=head2 __PACKAGE__->meta->document

Returns a C<L<MooseX::Documentation::Class>> instance containing all the
guts of this packages Documentation.

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-documentation at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Documentation>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooseX::Documentation


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-Documentation>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-Documentation>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-Documentation>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-Documentation/>

=back

=head1 ACKNOWLEDGEMENTS

There are a few people who helped spurn in the inception of this code, whether it be putting up with my stupidty, debating how it would best be implemented, kicking me for doing it wrong, and other general good direction giving techniques.

However, for all things wrong, thats likely my fault.

=over 4

=item Jesse Luehrs ( DOY )

=item Dave Rolsky  ( DROLSKY )

=item Shawn M Moore ( SARTAK )

=back

=head1 COPYRIGHT & LICENSE

Copyright 2009 Kent Fredric, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

