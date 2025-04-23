FROM alpine:3.21.3

ADD build-toolchain.sh /opt/build-toolchain.sh

RUN /opt/build-toolchain.sh

ENV PATH "/opt/toolchain:$PATH"
ENV ARCOS "true"
ENV BUILDROOT "/opt/"

WORKDIR /opt
