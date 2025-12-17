FROM alpine:latest 
WORKDIR /lib
COPY  . .
CMD ["echo", "Mr Lowat Bakery SMCMG17 image built successfully"]
