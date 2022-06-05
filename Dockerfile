FROM alpine:3.14

RUN apk update && apk add curl postgresql-client python3 tar
RUN python3 -m ensurepip
RUN pip3 install -U pip
RUN pip3 install csvkit

COPY ./src/download.sh /src/download.sh
RUN chmod +x /src/download.sh

COPY ./src/extract.sh /src/extract.sh
RUN chmod +x /src/extract.sh

COPY ./src/copy.sh /src/copy.sh
RUN chmod +x /src/copy.sh

ENTRYPOINT [ "/bin/sh" ]
