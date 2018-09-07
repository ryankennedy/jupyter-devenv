FROM python:3.7.0-slim-stretch

RUN echo "manylinux1_compatible = True" > /usr/local/lib/python3.7/site-packages/_manylinux.py

RUN apt-get update && apt-get install -y --no-install-recommends sudo
RUN pip install --no-cache-dir pipenv jupyterlab

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
