use strict;
use warnings;

use Test::More;
use DBIx::Class::Storage::Debug::PrettyPrint;

my $cap;
open my $fh, '>', \$cap;

my $pp = DBIx::Class::Storage::Debug::PrettyPrint->new({
   profile => 'none',
   no_repeats => 1,
   fill_in_placeholders => 1,
   placeholder_surround => [qw(' ')],
   show_progress => 0,
});

$pp->debugfh($fh);

$pp->query_start('SELECT * FROM frew WHERE id = ?', q('1'));
is(
   $cap,
   qq(SELECT * FROM frew WHERE id = '1'\n\n),
   'SQL Logged'
);

open $fh, '>', \$cap;
$pp->query_start('SELECT * FROM frew WHERE id = ?', q('2'));
is(
   $cap,
   qq(... : '2'\n\n),
   'Repeated SQL ellided'
);

open $fh, '>', \$cap;
$pp->query_start('SELECT * FROM frew WHERE id = ?', q('3'));
is(
   $cap,
   qq(... : '3'\n\n),
   'Repeated SQL ellided'
);

open $fh, '>', \$cap;
$pp->query_start('SELECT * FROM frew WHERE id = ?', q('4'));
is(
   $cap,
   qq(... : '4'\n\n),
   'Repeated SQL ellided'
);

open $fh, '>', \$cap;
$pp->query_start('SELECT * FROM bar WHERE id = ?', q('4'));
is(
   $cap,
   qq(SELECT * FROM bar WHERE id = '4'\n\n),
   'New SQL Logged'
);

open $fh, '>', \$cap;
$pp->query_start('SELECT * FROM frew WHERE id = ?', q('1'));
is(
   $cap,
   qq(SELECT * FROM frew WHERE id = '1'\n\n),
   'New SQL Logged'
);

done_testing;