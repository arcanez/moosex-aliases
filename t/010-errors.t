#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 3;
use Test::Exception;

{
    package Foo;
    use Moose;
    use MooseX::Aliases;

    ::throws_ok { alias foo => 'bar' } qr/^Cannot find method bar to alias/,
        "aliasing a non-existent method gives an appropriate error";

    has foo => (
        is    => 'ro',
        isa   => 'Int',
        alias => [qw(bar baz quux)],
    )
}

{
    throws_ok { Foo->new(bar => 1, baz => 2) }
              qr/^Conflicting init_args: \(bar, baz\)/,
              "conflicting init_args give an appropriate error";

    if (Foo->meta->is_mutable) {
        Foo->meta->make_immutable;
        redo;
    }
}
