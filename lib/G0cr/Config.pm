package G0cr::Config;
use v5.14;
use strict;
use warnings;
use Mojo::JSON qw(decode_json);

BEGIN {
    defined($ENV{G0CR_CONFIG_FILE}) or die "G0CR_CONFIG_FILE env var is undefined.";
    -f $ENV{G0CR_CONFIG_FILE} or die "G0CR_CONFIG_FILE env var does not point to a file.";
}

sub CONFIG_FILE() {
    $ENV{G0CR_CONFIG_FILE}
}

sub load {
    state $config;
    return $config if defined $config;
    open my $fh, "<", CONFIG_FILE or die $!;
    local $/ = undef;
    my $content = <$fh>;
    $config = decode_json( $content );
}

1;
