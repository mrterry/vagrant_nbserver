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
RUN apt-get install -y openssh-server supervisor patch libpq-dev
RUN mkdir -p /var/run/sshd
# turn off pam otherwise the ssh login will not work
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN echo 'root:nbserver' | chpasswd

# initialize the conda environment
ADD http://repo.continuum.io/miniconda/Miniconda-3.6.0-Linux-x86_64.sh /home/nbserver/miniconda.sh
RUN /bin/bash /home/nbserver/miniconda.sh -b -p /home/nbserver/miniconda
RUN rm /home/nbserver/miniconda.sh
ENV PATH $PATH:/home/nbserver/miniconda/bin
RUN conda update conda --yes

# add the supervisor config file
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# add the conda config.  adds additional binstar package repositories
ADD condarc /home/nbserver/.condarc

# give everything to the nbserver user
RUN chown -R nbserver:nbserver /home/nbserver

# switch user and install packages
USER nbserver
RUN conda install --yes \
    beautiful-soup \
    binstar \
    conda-build \
    cython \
    dateutil \
    flake8 \
    ipython \
    ipython-notebook \
    libxml2 \
    libxslt \
    matplotlib \
    mock \
    networkx \
    nltk \
    nose \
    numba \
    numexpr \
    numpy \
    pandas \
    pillow \
    pip \
    pytest \
    scikit-image \
    scikit-learn \
    scipy \
    sqlalchemy \
    statsmodels \
    sympy 

RUN conda install --yes psycopg2
#RUN conda install --yes redshift-sqlalchemy

# supervisor runs as root.  so switch back to root.
USER root
# run the notebook server on port 8081
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
EXPOSE 22 8081
