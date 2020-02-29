# base image is Debian GNU/Linux 9
FROM rocker/r-ver:3.6.1
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
            zlib1g-dev
RUN install2.r --error --repos https://cran.rstudio.com \
    data.table \
    dplyr \
    jsonlite \
    magrittr \
    purrr \
    stringr && \
    install2.r -e -r https://cran.rstudio.com --deps \
    rlist
COPY R /opt/org/R
WORKDIR /opt/org/R
