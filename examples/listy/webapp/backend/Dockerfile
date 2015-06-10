FROM conjurinc/openresty 

EXPOSE 80

RUN apk update
RUN apk add curl
RUN apk add bash

ADD launch /

CMD [ "/launch" ]
