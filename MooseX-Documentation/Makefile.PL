use inc::Module::Install;

name     'MooseX-Documentation';
all_from 'lib/MooseX/Documentation.pm';
author   'Kent Fredric <kentnl@cpan.org>';
license  'perl';
version  '0.0100';

repository 'git://github.com/kentfredric/MooseX-Documentation.git';

requires 'Moose';
requires 'Moose::Exporter';
requires 'namespace::clean';
requires 'Carp';

test_requires 'Test::More';

WriteAll;

