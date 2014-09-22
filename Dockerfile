FROM phusion/baseimage:latest

# RUN useradd ---create-home --password ubuntu ubuntu

#RUN apt-get update
#RUN apt-get upgrade -y

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
#psycopg2 geoalchemy descartes 
#RUN conda install anaconda psycopg2 --yes

EXPOSE 8888
# CMD ipython notebook --no-browser --ip=0.0.0.0 --port 8888
# CMD /bin/bash
CMD echo "done"
