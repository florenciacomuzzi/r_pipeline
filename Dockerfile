# base image is Debian GNU/Linux 9
FROM rocker/r-ver:3.6.1
# leverage with $ docker build --build-arg <varname>=<value>
ARG CRAN_URI=https://cran.rstudio.com
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
            zlib1g-dev
RUN install2.r --error --repos $CRAN_URI \
    data.table \
    dplyr \
    jsonlite \
    magrittr \
    purrr \
    stringr && \
    install2.r -e -r $CRAN_URI --deps \
    rlist
COPY R /opt/org/R
WORKDIR /opt/org/R
