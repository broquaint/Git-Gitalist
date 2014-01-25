use MooseX::Declare;

class Git::Gitalist::CollectionOfRepositories::FromDirectory::WhiteList
    extends Git::Gitalist::CollectionOfRepositories::FromDirectory {
    use MooseX::Types::Common::String qw/NonEmptySimpleStr/;
    use MooseX::Types::Path::Class qw/File Dir/;

    has whitelist => (
        isa      => File,
        is       => 'ro',
        required => 1,
        coerce   => 1,
    );

    method debug_string { 'repository directory ' . $self->repo_dir . ' whitelist file ' . $self->whitelist }

    method _build_repositories {
        return [
            map  Git::Gitalist::Repository->new($_),
            grep -d $_,
            map  $self->repo_dir->subdir($_),
            map  [split]->[0], $self->whitelist->slurp(chomp => 1)
        ];
    }
}

__END__
=head1 NAME

Git::Gitalist::CollectionOfRepositories::FromDirectory::WhiteList - Model of a repositories listed in a file in a given directory.

=head1 SYNOPSIS

    my $repo = Git::Gitalist::CollectionOfRepositories::FromDirectory::WhiteList->new(
      repo_dir  => $Dir,
      whitelist => 'projects.list',
    );
    my $repository_list = $repo->repositories;
    my $first_repository = $repository_list->[0];
    my $named_repository = $repo->get_repository('Gitalist');

=head1 DESCRIPTION

This class provides a list of Repositories found in the given
directory and specified in a given whitelist file.

=head1 ATTRIBUTES

=head2 whitelist (C<Path::Class::File>)

The file containing the available repositories. Each line specifies a
different repository within L</repo_dir>.

=head1 SEE ALSO

L<Git::Gitalist::CollectionOfRepositories>,
L<Git::Gitalist::Repository>,
L<Git::Gitalist::CollectionOfRepositories::FromDirectory>

=head1 AUTHORS

See L<Gitalist> for authors.

=head1 LICENSE

See L<Gitalist> for the license.

=cut
