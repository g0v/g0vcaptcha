package G0cr;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  my $route = $self->routes;

  $route->get('/')->to('welcome#welcome');
  $route->get('/upload')->to('welcome#upload');

  my $document = $route->any("/document")->to("document#");
  $document->get("/")->to('#list');
  $document->post("/")->to('#upload');
}

1;
