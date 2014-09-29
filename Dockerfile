FROM ubuntu:14.04

# RUN useradd -m nbserver
RUN useradd -m nbserver

# update the apt repos
RUN apt-get -y update
RUN apt-get -y upgrade

# openssh-server for ssh access
# supervisor for managing the ipython notebook server
# patch for conda-build
# libpq-dev for psycopg2
# unip to unzip the Stanford NLP stuff
# default-jre to run the Stanford NLP stuff
RUN apt-get install -y openssh-server supervisor patch libpq-dev unzip default-jre

# Configure ssh
RUN mkdir -p /var/run/sshd
# turn off pam otherwise the ssh login will not work
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# Set passwords so I can log in.  Yes this is highly insecure.
RUN echo 'nbserver:nbserver' | chpasswd
RUN echo 'root:nbserver' | chpasswd

# initialize the conda environment
ADD http://repo.continuum.io/miniconda/Miniconda-3.6.0-Linux-x86_64.sh /home/nbserver/miniconda.sh
RUN /bin/bash /home/nbserver/miniconda.sh -b -p /home/nbserver/miniconda
RUN rm /home/nbserver/miniconda.sh
ENV PATH $PATH:/home/nbserver/miniconda/bin
RUN conda update conda --yes

# Download & unpack Stanford NLP libs
ADD http://www-nlp.stanford.edu/software/stanford-corenlp-full-2014-08-27.zip /opt/stanford_nlp/corenlp.zip
ADD http://www-nlp.stanford.edu/software/stanford-ner-2014-08-27.zip /opt/stanford_nlp/ner.zip
RUN cd /opt/stanford_nlp && unzip /opt/stanford_nlp/corenlp.zip
RUN cd /opt/stanford_nlp && unzip /opt/stanford_nlp/ner.zip

# add the supervisor config file
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# add the conda config.  adds additional binstar package repositories
ADD condarc /home/nbserver/.condarc

# give everything to the nbserver user
RUN chown -R nbserver:nbserver /home/nbserver

# switch user and install packages
USER nbserver

# install nltk and its data.  do this as a separate step to make caching easier.
RUN conda install nltk --yes
RUN /home/nbserver/miniconda/bin/python -m nltk.downloader all

RUN conda install --yes \
    beautiful-soup \
    binstar \
    conda-build \
    cython \
    dateutil \
    flake8 \
    gensim \
    ipython \
    ipython-notebook \
    libxml2 \
    libxslt \
    matplotlib \
    mock \
    networkx \
    nose \
    numba \
    numexpr \
    numpy \
    pandas \
    pillow \
    pip \
    pytables \
    pytest \
    scikit-image \
    scikit-learn \
    scipy \
    sqlalchemy \
    statsmodels \
    sympy \ 
    toolz

# 3rd party libs
RUN conda install --yes \
    psycopg2 \
    redshift-sqlalchemy
# RUN conda install --yes psycopg2
# RUN conda install --yes redshift-sqlalchemy

USER root


# supervisor runs as root.  so switch back to root.
USER root
# run the notebook server on port 8081
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
EXPOSE 22 8081
