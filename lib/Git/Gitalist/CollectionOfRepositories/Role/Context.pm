use MooseX::Declare;

role Git::Gitalist::CollectionOfRepositories::Role::Context {
    method implementation_class {
        $self->meta->name
    }
     
    method ACCEPT_CONTEXT($ctx) {
        return $self;
    }
}
