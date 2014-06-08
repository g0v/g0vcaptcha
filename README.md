G0cr / g0vcaptcha
=================

## Dev
---

* perl (>= 5.14)
* ElasticSearch
* tesseract
* ImageMagick
* GNU parallel

### Mac Homebrew:

    brew install elasticsearch
    brew install tesseract --all-languages
    brew install imagemagick
    brew install parallel

### perl stack setup

Setup perlbrew

    \curl -L http://install.perlbrew.pl | bash
    perlbrew install perl-5.20.0 --as project-g0cr --notest
    perlbrew use project-g0cr
    perlbrew install-cpanm

Deal with CPAN dependencies

    cpanm --notest Carton
    carton install

Try running the mojo webapp:

    elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml -d
    carton exec morbo ./script/g0cr
