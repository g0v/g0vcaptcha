package G0cr;
use Mojo::Base 'Mojolicious';
use G0cr::Config;

# This method will run once at server start
sub startup {
  my $self = shift;

  $self->config(%{ G0cr::Config->load });

  my $route = $self->routes;
  $route->get('/')->to('welcome#welcome');
  $route->get('/upload')->to('welcome#upload');
  $route->get('/browse')->to('document#list');

  my $document = $route->any("/document")->to("document#");
  $document->get("/")->to('#list');
  $document->get("/:sha1")->to('#get');
  $document->post("/")->to('#upload');
}

1;
