FROM ubuntu:latest
# If you leave this out apt will hang at choosing a geographic area for your timezone, it expects a manual input
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get upgrade -y && apt-get install \
    python3 \
    python3-dev \
    python3-pip \
    libfontconfig g++ \
    make \
    cmake \
    unzip \
    chromium-browser \
    libnss3 \
    wget \
    curl \
    libcurl4-openssl-dev -y

RUN curl -SL https://chromedriver.storage.googleapis.com/2.37/chromedriver_linux64.zip > chromedriver.zip
RUN unzip chromedriver.zip -d bin/

RUN curl -SL https://github.com/adieuadieu/serverless-chrome/releases/download/v1.0.0-37/stable-headless-chromium-amazonlinux-2017-03.zip > headless-chromium.zip
RUN unzip headless-chromium.zip -d bin/

COPY ./requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt
COPY ./scraper.py /opt/scraper.py

WORKDIR /opt
#CMD ["python3", "scraper.py"]
ENTRYPOINT ["python3", "-m", "awslambdaric"]
CMD [ "scraper.handler" ]
