# Build an image that can do training and inference in SageMaker
# This is a Python 3 image that uses the nginx, gunicorn, flask stack
# for serving inferences in a stable way.

FROM ubuntu:16.04

MAINTAINER Stuart Loxton <stuart.loxton@xinja.com.au>

RUN apt-get -y update && apt-get install -y --no-install-recommends \
         wget \
         python3 \
         nginx \
         ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install all of the packages
RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py
RUN pip3 install numpy
RUN pip3 install scipy
RUN pip3 install scikit-learn
RUN pip3 install pandas
RUN pip3 install flask
RUN pip3 install gevent
RUN pip3 install gunicorn
RUN pip3 install tensorflow
RUN pip3 install keras
RUN pip3 install boto3
RUN rm -rf /root/.cache

# Env Variables
ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PATH="/opt/program:${PATH}"

# Set up the program in the image
COPY ann /opt/program
WORKDIR /opt/program

RUN chmod +x serve
RUN chmod +x train
