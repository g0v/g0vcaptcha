package G0cr;
use Mojo::Base 'Mojolicious';
use G0cr::Config;

# This method will run once at server start
sub startup {
  my $self = shift;
  $self->plugin('RenderFile');

  $self->config(%{ G0cr::Config->load });

  if (defined $self->config->{"mojo_secret"}) {
      $self->secrets(delete $self->config->{"mojo_secret"});
  }

  my $route = $self->routes;
  $route->get('/')->to('welcome#welcome');
  $route->get('/upload')->to('welcome#upload');
  $route->get('/browse')->to('document#list');

  my $document = $route->any("/document")->to("document#");
  $document->get("/")->to('#list');
  $document->post("/")->to('#upload');
  $document->get("/:sha1")->to('#show')->name("show_document");
  $document->get("/:sha1/page/:page.html")->to('#show_page');
  $document->get("/:sha1/page/:page.png")->to('#show_page_png');
  $document->get("/:sha1/page_thumbnail/:page.png")->to('#show_page_thumbnail_png');

  $route->get("/slice/(document_sha1)-(page_number)-(bbox_csv)")->to("slice#get")->name("slice");
}

1;
