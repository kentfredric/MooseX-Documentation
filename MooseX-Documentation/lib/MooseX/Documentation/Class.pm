package MooseX::Documentation::Class;

# $Id:$
use strict;
use warnings;
use Moose;
use MooseX::Documentation::Method;

our $VERSION = '0.0100';

use namespace::clean -except => [qw( meta )];

has methods => (
    isa     => 'HashRef[ MooseX::Documentation::Method ]',
    is      => 'rw',
    default => sub { +{} },
);

has for_package => (
    isa      => 'ClassName|RoleName',
    is       => 'ro',
    required => 1,
);

sub trim_whitespace
{
    my $self   = shift;
    my $string = shift;
    $string =~ s/^\s*//gm;
    $string =~ s/\s*$//gm;
    if ( $string =~ /\n/ )
    {
        return [ split /\n/, $string ];
    }
    return $string;
}

sub add_method
{
    my $self    = shift;
    my %params  = @_;
    my $name    = $params{name};
    my %options = %{ $params{options} };

    my $method = MooseX::Documentation::Method->new( name => $name, brief => $self->trim_whitespace( $options{brief} ) );
    delete $options{brief};
    $method->unspecified( \%options );
    $self->methods->{ $name } = $method;
    return $self;
}

sub as_pod
{
    my $self = shift;
    return $self->_pod_h1('methods');
}

sub _text
{
    my $self     = shift;
    my $title    = shift;
    my $subtitle = shift;
    my $field    = shift;
    my $data     = $self->{$title}->{$subtitle}->{$field};
    my $out      = '';
    my $prefix   = '';

    if ( $field =~ m/^example/ )
    {
        $prefix = q{ } x 4;
    }
    if ( not ref $data )
    {
        $out .= $prefix . $data;
    }
    if ( ref $data eq 'ARRAY' )
    {
        $out .= $prefix . $_ . "\n" for @{$data};
    }
    return $out;
}

sub _pod_h1
{
    my $self  = shift;
    my $title = shift;
    return sprintf qq{\n=head1 %s\n\n%s}, uc($title), join '',
      map { $self->_pod_h2( $title, $_ ) } keys %{ $self->{$title} };
}

sub _pod_h2
{
    my $self     = shift;
    my $title    = shift;
    my $subtitle = shift;
    return sprintf qq{\n=head2 ->%s\n\n%s\n\n=over 4\n\n%s\n=back\n}, $subtitle,
      $self->_text( $title, $subtitle, 'brief' ), join '',
      map { $self->_pod_item( $title, $subtitle, $_ ) }
      grep { $_ ne 'brief' } keys %{ $self->{$title}->{$subtitle} };
}

sub _pod_item
{
    my $self     = shift;
    my $title    = shift;
    my $subtitle = shift;
    my $field    = shift;
    return sprintf qq{\n=item * %s\n\n%s\n}, $field,
      $self->_text( $title, $subtitle, $field );
}

__PACKAGE__->meta->make_immutable;
1;

