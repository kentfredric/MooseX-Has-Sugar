package  T4Values::EMixed;

# $Id:$
use strict;
use warnings;
use MooseX::Has::Sugar::Minimal;
use MooseX::Has::Sugar qw( :attrs );
use namespace::autoclean;

sub generated {
  {
    isa => 'Str',
    is  => ro,
    required, lazy, lazy_build, coerce, weak_ref, auto_deref
  };
}

sub manual {
  {
    isa        => 'Str',
    is         => 'ro',
    required   => 1,
    lazy       => 1,
    lazy_build => 1,
    coerce     => 1,
    weak_ref   => 1,
    auto_deref => 1,
  };
}

1;

