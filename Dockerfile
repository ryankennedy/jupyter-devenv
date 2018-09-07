FROM python:3.7.0-alpine3.8

RUN apk --update add --no-cache libstdc++ libc6-compat

COPY Pipfile* /tmp/
WORKDIR /tmp
RUN echo "manylinux1_compatible = True" > /usr/local/lib/python3.7/site-packages/_manylinux.py

RUN apk --update add --no-cache --virtual .build-deps make automake gcc g++ subversion python3-dev
RUN pip install --no-cache-dir jupyterlab pipenv matplotlib pandas numpy==1.14.3
RUN apk del .build-deps

RUN adduser -S jupyter

USER jupyter
RUN mkdir /home/jupyter/.jupyter
COPY jupyter_notebook_config.json /home/jupyter/.jupyter/

RUN mkdir /home/jupyter/work
RUN echo "Mount a bind volume here" > /home/jupyter/work/README
VOLUME ["/home/jupyter/work"]

WORKDIR /home/jupyter/work

EXPOSE 8888/tcp

ENTRYPOINT ["jupyter-lab"]
