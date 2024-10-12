FROM python:3.12-bookworm

RUN apt-get update
RUN apt-get install -y \
    curl autoconf automake libtool python3-dev pkg-config

# libpostal installation
WORKDIR /srv

RUN git clone https://github.com/openvenues/libpostal

WORKDIR /srv/libpostal

RUN ./bootstrap.sh
RUN ./configure --datadir=/var/postal
RUN make
RUN ldconfig

# web server installation
COPY ./requirements.txt /srv/libpostal
RUN pip install requirements.txt

COPY ./main.py /srv/libpostal

CMD ["python", "/srv/libpostal/main.py"]