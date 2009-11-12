use strict;
use warnings;
use FindBin qw/$Bin/;
use Test::More qw/no_plan/;
use Test::Exception;
use Data::Dumper;

BEGIN { use_ok 'Gitalist::Git::Project' }

dies_ok {
    my $proj = Gitalist::Git::Project->new();
} 'New project with no args';

use Path::Class;
my $gitdir = dir("$Bin/lib/repositories/repo1");

my $proj = Gitalist::Git::Project->new($gitdir);
isa_ok($proj, 'Gitalist::Git::Project');
is($proj->path, $gitdir, 'repository path is set');
is($proj->name, qw/repo1/, 'repository name is set');
is($proj->description, qq/some test repository/, 'repository description loaded');
isa_ok($proj->last_change, 'DateTime', 'last_change');

is($proj->info->{name}, qw/repo1/, 'repo name in info hash');

my %references = %{$proj->references};
ok(keys %references >= 2, '->references hash has elements');
is($references{'36c6c6708b8360d7023e8a1649c45bcf9b3bd818'}->[0], 'heads/master', 'reference looks ok');
my @heads = @{$proj->heads};
ok(scalar @heads > 1, '->heads list has more than one element');
my %head = %{$heads[1]};
ok(keys %head == 3, '->heads[1] has the right number of keys');
ok(defined $head{sha1}, '->heads[1]-sha1 is defined');
ok(defined $head{name}, '->heads[1]-name is defined');
is($proj->head_hash, '36c6c6708b8360d7023e8a1649c45bcf9b3bd818', 'head_hash for HEAD is correct');
is($proj->head_hash('refs/heads/master'), '36c6c6708b8360d7023e8a1649c45bcf9b3bd818', 'head_hash for refs/heads/master is correct');
is($proj->head_hash('rafs/head/mister'), undef, 'head_hash for rafs/head/mister is undef');

is(scalar $proj->list_tree, 2, 'expected number of entries in tree');
isa_ok(($proj->list_tree)[1], 'Gitalist::Git::Object');

# Return an ::Object from a sha1
my $obj1 = $proj->get_object('5716ca5987cbf97d6bb54920bea6adde242d87e6');
isa_ok($obj1, 'Gitalist::Git::Object');

my $hbp_sha1 = $proj->hash_by_path('36c6c6708b8360d7023e8a1649c45bcf9b3bd818', 'dir1/file2');
my $obj2 = $proj->get_object($hbp_sha1);
is($obj2->type, 'blob', 'hash_by_path obj is a file');
is($obj2->contents, "foo\n", 'hash_by_path obj is a file');
