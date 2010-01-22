#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use FindBin qw/$Bin/;
use lib "$Bin/lib";

BEGIN {
    $ENV{GITALIST_CONFIG} = $Bin;
    $ENV{GITALIST_REPO_DIR} = '';
    use_ok 'Catalyst::Test', 'Gitalist';
}
use TestGitalist;

for my $p ('', qw/ repo1 nodescription bare.git opml search /) {
    my $path = '/' . $p;
    ok( request($path)->is_success, "$path should succeed");
}

my $response = request('/DoesNotExist');
is $response->code, 404, 'invalid repository 404s';
like $response->content, qr/Page not found/, 'invalid repository handled correctly';


{
  # URI tests for repo1
  local *test = curry_test_uri('repo1');
  test('');
  test('search');
  test('shortlog');
  test('log');
  test('reflog');
  test('36c6c6708b8360d7023e8a1649c45bcf9b3bd818');
  test('36c6c6708b8360d7023e8a1649c45bcf9b3bd818/tree');
  test('36c6c6708b8360d7023e8a1649c45bcf9b3bd818/diff');
  test('36c6c6708b8360d7023e8a1649c45bcf9b3bd818/patch');
  test('36c6c6708b8360d7023e8a1649c45bcf9b3bd818/patches/1');
  test('36c6c6708b8360d7023e8a1649c45bcf9b3bd818/patches/2');
  test('36c6c6708b8360d7023e8a1649c45bcf9b3bd818/history/dir1');
  test('36c6c6708b8360d7023e8a1649c45bcf9b3bd818/blame/file1');
  test('36c6c6708b8360d7023e8a1649c45bcf9b3bd818/raw/file1');
  test('36c6c6708b8360d7023e8a1649c45bcf9b3bd818/blob/file1');

  TODO: {
      local $TODO = "FIXME";
      test('search', 'type=commit&text=added');

      # FIXME - What's the difference here?
      #test('patch', 'h=3f7567c7bdf7e7ebf410926493b92d398333116e');
      #test('patch', 'h=3f7567c7bdf7e7ebf410926493b92d398333116e;hp=3bc0634310b9c62222bb0e724c11ffdfb297b4ac');
      #test('patches', 'h=3f7567c7bdf7e7ebf410926493b92d398333116e');
      #test('patches', 'h=3f7567c7bdf7e7ebf410926493b92d398333116e;hp=3bc0634310b9c62222bb0e724c11ffdfb297b4ac');
  }
}

done_testing;
