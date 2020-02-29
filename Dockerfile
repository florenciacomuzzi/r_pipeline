FROM rocker/r-ver:3.6.1
# Install R packages
RUN install2.r --error \
    data.table \
    dplyr \
    jsonlite \
    magrittr \
    purrr \
    rlist \
    stringr
 
