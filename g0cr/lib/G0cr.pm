package G0cr;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  my $route = $self->routes;

  $route->get('/')->to('welcome#welcome');
}

1;
