package G0cr::Welcome;
use Mojo::Base 'Mojolicious::Controller';

sub welcome {
    my $self = shift;
    $self->render;
}

sub upload {
    my $self = shift;
    $self->render;
}

1;
