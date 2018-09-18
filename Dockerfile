FROM debian:stretch-slim as downloader

RUN apt-get update && apt-get install -y --no-install-recommends curl software-properties-common
RUN curl -sL https://deb.nodesource.com/setup_8.x > /tmp/node_8.x

FROM python:3.7.0-slim-stretch

RUN echo "manylinux1_compatible = True" > /usr/local/lib/python3.7/site-packages/_manylinux.py

COPY --from=downloader /tmp/node_8.x /tmp/node_8.x
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2
RUN cat /tmp/node_8.x | bash -

RUN apt-get update && apt-get install -y --no-install-recommends sudo nodejs git
RUN pip install --no-cache-dir pipenv jupyterlab nbdime
RUN nbdime extensions --enable

RUN adduser jupyter
RUN echo "jupyter ALL = NOPASSWD: `which apt-get`" >> /etc/sudoers.d/jupyter
USER jupyter
RUN mkdir /home/jupyter/.jupyter
COPY jupyter_notebook_config.json /home/jupyter/.jupyter/
COPY run_jupyter.sh /home/jupyter/run_jupyter.sh

RUN mkdir /home/jupyter/work
RUN echo "Mount a bind volume here" > /home/jupyter/work/README
VOLUME ["/home/jupyter/work"]

WORKDIR /home/jupyter/work
EXPOSE 8888/tcp
CMD ["/home/jupyter/run_jupyter.sh"]
