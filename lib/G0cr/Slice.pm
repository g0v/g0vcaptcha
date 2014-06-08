package G0cr::Slice;
use Mojo::Base 'Mojolicious::Controller';

sub get {
    my $self = shift;

    my $storage = $self->app->config('storage');
    my @v = $self->param(['document_sha1', 'page_number', 'bbox_csv']);

    my $f = join "/", $storage, $v[0], "page", "page-$v[1]", "$v[2].png";
    $self->render_file( filepath => $f );
}

1;
