package G0cr::Config;
use strict;
use warnings;

sub load {
    return {
        storage => "/tmp/g0cr",
        elasticsearch_node => {
            host => '127.0.0.1',
            port => '9200'
        }
    }
}

1;
