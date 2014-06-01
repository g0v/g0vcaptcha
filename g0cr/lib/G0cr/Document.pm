package G0cr::Document;
use Mojo::Base 'Mojolicious::Controller';

use Digest::SHA1 qw(sha1_hex);
use Mojo::JSON qw(encode_json);

sub upload {
    my $self = shift;
    my $uploaded_file = $self->req->upload('f');

    my $upload_dir = $self->app->config('storage');
    my $sha1_digest = sha1_hex( $uploaded_file->slurp );

    my $dir = $upload_dir . "/" . $sha1_digest;
    mkdir($dir);
    $uploaded_file->move_to( "${dir}/source.pdf" );

    my $info = {
        filename => $uploaded_file->filename,
        size => $uploaded_file->size
    };

    open(my $fh, ">", "${dir}/info.json") or die $!;
    print $fh encode_json($info);
    close($fh);

    index_

    $self->redirect_to(action => "list");
}

sub list {
    my $self = shift;
    $self->render;
}

1;