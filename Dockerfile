FROM krlmlr/debian-ssh:latest

# toolbox for automatic knowledge mining

RUN apt-get update && \
        apt-get install -y  \
        minicpan \
        cpanminus \
        memcached \
        wordnet \
        build-essential

RUN cpanm Mojolicious \
         Config::Auto \
         Digest::SHA1 \
         Data::Printer \
         Sysadm::Install \
         Storable::CouchDB \
         Cache::Memcached::Fast \
         Statistics::Basic \
         WWW::Wikipedia

RUN cpanm Search::ContextGraph AI::MicroStructure::Context  --force; exit 0 # unfortunatly fails... so lets return 0 ;-)

VOLUME  [ "/root/data-hub", "/root/now" ]

ENV SHELL /bin/bash
ADD https://raw.githubusercontent.com/santex/AI-MicroStructure/tests/lib/AI/MicroStructure/Object.pm  /root/Object.pm
ADD https://raw.githubusercontent.com/santex/AI-MicroStructure/tests/lib/AI/MicroStructure/ObjectSet.pm  /root/ObjectSet.pm

RUN cpanm --look AI::MicroStructure
RUN cd /root/.cpanm/work/*/AI-MicroStructure-* && \
        pwd > /root/micro-dir.txt && \
        cpanm . && \ 
        perl Makefile.PL

RUN cd $(cat /root/micro-dir.txt) && \
        mkdir -p ./blib/arch/AI/MicroStructure && \
        mv /root/Object*.pm ./blib/arch/AI/MicroStructure/ && \
        make install

COPY micro-config /root/.micro


