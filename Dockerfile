FROM alpine:latest

RUN apk update && apk add curl musl-dev pigz postgresql-client pv tar

RUN curl -LJO https://github.com/jqnatividad/qsv/releases/download/0.58.2/qsv-0.58.2-x86_64-unknown-linux-musl.zip
RUN unzip qsv-0.58.2-x86_64-unknown-linux-musl.zip

COPY ./src/download.sh /src/download.sh
RUN chmod +x /src/download.sh

COPY ./src/extract.sh /src/extract.sh
RUN chmod +x /src/extract.sh

COPY ./src/copy.sh /src/copy.sh
RUN chmod +x /src/copy.sh

ENTRYPOINT [ "/bin/sh" ]
