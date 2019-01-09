FROM alpine

RUN apk update && apk add --clean \
    g++ \
    git \
    cmake \
    build-base \
    boost-system \
    boost-thread \
    boost-filesystem \
    boost-program_options \
    boost-regex \
    boost-iostreams

WORKDIR /data

RUN git clone https://github.com/m-schuetz/LAStools.git \
    && cd /data/LAStools/LASzip \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make \
    && make install

ADD . /data/PotreeConverter

RUN mkdir PotreeConverter/build \
    && cd PotreeConverter/build \
    && cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DLASZIP_INCLUDE_DIRS=/data/LAStools/LASzip/dll \
        -DLASZIP_LIBRARY=/data/LAStools/LASzip/build/src/liblaszip.so \
        .. \
    && make \
    && make install

RUN cp -R /data/PotreeConverter/PotreeConverter/resources/ /data
