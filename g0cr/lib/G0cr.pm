package G0cr;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  if ($self->mode eq 'development') {
      mkdir("/tmp/g0cr_upload");
      $self->config( upload_dir => "/tmp/g0cr_upload" );
  }

  my $route = $self->routes;
  $route->get('/')->to('welcome#welcome');
  $route->get('/upload')->to('welcome#upload');

  my $document = $route->any("/document")->to("document#");
  $document->get("/")->to('#list');
  $document->post("/")->to('#upload');
}

1;
