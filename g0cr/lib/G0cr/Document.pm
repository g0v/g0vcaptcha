package G0cr::Document;
use Mojo::Base 'Mojolicious::Controller';

use Digest::SHA1 qw(sha1_hex);
use Mojo::JSON qw(encode_json decode_json);

use G0cr::ElasticSearch;

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

    my $es = G0cr::ElasticSearch->new();
    my ($status, $res) = $es->post(
        body => {
            filename => $info->{filename},
            size => $info->{size},
            sha1 => $sha1_digest,
        }
    );

    if (substr($status,0,1) ne '2') {
        $self->app->log->debug("status = $status. res = " . encode_json($res));
    }

    $self->redirect_to(action => "list");
}

sub list {
    my $self = shift;
    my $es = G0cr::ElasticSearch->new;
    my $res = $es->search(
        body => {
            query => { match_all => {} },
            size => 25,
        }
    );

    $self->render(
        documents => [ map { $_->{_source} } @{$res->{hits}{hits}} ]
    );
}

sub show {
    my $self = shift;
    my $sha1 = $self->stash("sha1");
    my $es = G0cr::ElasticSearch->new;
    my $res = $es->get( id => $sha1 );

    my $storage = $self->app->config('storage');

    my $hocr_pages = [];

    my $f = join("/", $storage, $sha1, "page", "cutword.json");
    if (-f $f) {
        local $/ = undef;
        open my $fh, "<", $f;
        my $x = <$fh>;
        $hocr_pages = decode_json($x);
        close $fh;
    }

    $self->render( document => $res->{_source}, hocr_pages => $hocr_pages );
}

1;
