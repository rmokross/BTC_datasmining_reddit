FROM rocker/r-base:latest

COPY ./BTC_reddit_scraper.R /app/BTC_reddit_scraper.R

COPY ./install_packages.R /app/install_packages.R

WORKDIR /app

RUN Rscript /app/install_packages.R

RUN Rscript /app/BTC_reddit_scraper.R
