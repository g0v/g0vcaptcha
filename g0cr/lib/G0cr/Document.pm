package G0cr::Document;
use Mojo::Base 'Mojolicious::Controller';

sub upload {
    my $self = shift;
    my $uploaded_file = $self->req->upload('f');

    $self->redirect_to(action => "list");
}

sub list {
    my $self = shift;
    $self->render;
}

1;
