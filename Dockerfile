FROM python:3.12-bookworm

# Install required dependencies
RUN apt-get update && \
    apt-get install -y \
    curl autoconf automake libtool python3-dev pkg-config gcc

# Install libpostal
WORKDIR /srv

RUN git clone https://github.com/openvenues/libpostal

WORKDIR /srv/libpostal

RUN ./bootstrap.sh
RUN ./configure --datadir=/var/postal
RUN make
RUN make install  # Install libpostal after building
RUN ldconfig  # Update the shared library cache

# Set environment variables to help pypostal find libpostal during pip install
ENV PKG_CONFIG_PATH=/srv/libpostal
ENV CFLAGS="-I/srv/libpostal/src"
ENV LDFLAGS="-L/srv/libpostal/src/.libs"
ENV LD_LIBRARY_PATH=/srv/libpostal/src/.libs:$LD_LIBRARY_PATH
CMD ["tail", "-f", "/dev/null"]

# Install the pypostal Python bindings
# RUN pip install postal


# web server installation
# COPY ./requirements.txt /srv/libpostal
# RUN pip install -r requirements.txt

# COPY ./main.py /srv/libpostal

# CMD ["python", "/srv/libpostal/main.py"]