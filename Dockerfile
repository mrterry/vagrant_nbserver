FROM ubuntu:14.04

# RUN useradd -m nbserver
RUN useradd --create-home --password nbserver nbserver

RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get install -y openssh-server supervisor
RUN mkdir -p /var/run/sshd
# turn off pam otherwise the ssh login will not work
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN echo 'root:nbserver' | chpasswd
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD http://repo.continuum.io/miniconda/Miniconda-3.6.0-Linux-x86_64.sh /root/miniconda.sh
RUN bash /root/miniconda.sh -b -p /opt/miniconda
ENV PATH $PATH:/opt/miniconda/bin

RUN conda update conda --yes
RUN conda install \
    cython ipython ipython-notebook matplotlib networkx nose numpy pandas scikit-image scikit-learn scipy statsmodels sympy \
    beautiful-soup binstar dateutil libxml2 libxslt nltk numba numexpr pillow pip sqlalchemy \
    flake8 mock pytest \
    --yes
# binstar
#RUN conda install anaconda psycopg2 --yes
#psycopg2 geoalchemy descartes 

RUN chown -R nbserver /opt/miniconda

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
EXPOSE 22 8081
