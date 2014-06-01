package G0cr::ElasticSearch;
use v5.14;
use strict;
use warnings;
use parent 'Elastijk::oo';

use G0cr::Config;

sub new {
    state $o;
    return $o if $o;
    my $class = shift;
    my $config = G0cr::Config->load;
    $o = Elastijk::oo->new(%{ $config->{elasticsearch_node} });
    bless $o, $class;
    return $o;
}

sub create_index {
    my $self = shift;

    return 0 if $self->exists(index => "g0cr_v0");

    $self->put(
        index => "g0cr_v0",
        body => {
            aliases => {
                "g0cr" => {}
            },
            settings => {
                index => {
                    number_of_shards => 2,
                    number_of_replicas => 0,
                }
            },
            mappings => {
                document => {
                    _id => {
                        path => "sha1",
                    },
                    properties => {
                        filename => { type => "string" },
                        size => { type => "long" },
                        sha1 => { type => "string", index => "not_analyzed" },
                        hocr_done => {
                            type => "date",
                            format => "basic_date_time_no_millis" # 20140601T220100Z
                        },
                        hocr_word => {
                            type => "nested",
                            properties => {
                                bbox => { type => "string", index => "not_analyzed" },
                                text => { type => "string" },
                            }
                        }
                    }
                }
            }
        }
    );
}

1;