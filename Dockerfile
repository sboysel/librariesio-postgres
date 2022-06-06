FROM rustlang/rust:nightly-alpine

RUN apk update && apk add curl musl-dev pigz postgresql-client pv tar

RUN cargo install qsv --features full

COPY ./src/download.sh /src/download.sh
RUN chmod +x /src/download.sh

COPY ./src/extract.sh /src/extract.sh
RUN chmod +x /src/extract.sh

COPY ./src/copy.sh /src/copy.sh
RUN chmod +x /src/copy.sh

ENTRYPOINT [ "/bin/sh" ]
