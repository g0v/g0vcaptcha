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
    $o = Elastijk::oo->new(
        %{ $config->{elasticsearch_node} }, # host, port
        index => "g0cr",
        type => "document",
    );
    bless $o, $class;
    return $o;
}

sub create_index {
    my $self = shift;

    return 0 if $self->exists(index => "g0cr_v0");

    delete $self->{index};
    delete $self->{type};

    my $Str = { type => "string" };
    my $Term = { type => "string", index => "not_analyzed" };
    my $Int = { type => "long" };

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
                        filename => $Str,
                        size => $Int,
                        sha1 => $Term,
                        tesseract_done => {
                            type => "date",
                            format => "basic_date_time_no_millis" # 20140601T220100Z
                        },
                        tesserract_output => {
                            type => "nested",
                            _id => {
                                path => "box_csv",
                            },
                            properties => {
                                text => $Str,
                                bbox_csv => $Term,
                                bbox => $Int,
                                page_number => $Int,
                                hocr_type => $Str,
                                hocr_id   => $Term,
                            }
                        }
                    }
                }
            }
        }
    );
    $self->{index} = "g0cr";
    $self->{type} = "document";
    return $self;
}

sub search_unprocessed {
    my $self = shift;
    return $self->search(body => {query => {constant_score => {filter => {missing => {field => "hocr_done"}}}}});
}

1;
