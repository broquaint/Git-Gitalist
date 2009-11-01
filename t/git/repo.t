use strict;
use warnings;
use FindBin qw/$Bin/;
use Test::More qw/no_plan/;

use Data::Dumper;

BEGIN { use_ok 'Gitalist::Git::Repo' }

my $repo = Gitalist::Git::Repo->new( repo_dir => "$Bin/../lib/repositories" );
isa_ok($repo, 'Gitalist::Git::Repo');

is($repo->repo_dir, "$Bin/../lib/repositories", "repo->repo_dir is correct" );

my $project_list = $repo->list_projects;
warn(Dumper($project_list));
isa_ok(@$project_list[0], 'Gitalist::Git::Project');
