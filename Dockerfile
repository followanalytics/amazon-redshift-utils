FROM python:2-slim

RUN echo "deb http://deb.debian.org/debian stretch-backports main contrib non-free" > /etc/apt/sources.list.d/stretch-backports.list
RUN apt-get update && mkdir -p /usr/share/man/man1 /usr/share/man/man7
RUN apt-get install -y libpq-dev postgresql-client gcc
RUN apt install -y -t stretch-backports redis-tools

WORKDIR /usr/src/app
COPY src/ /usr/src/app/
RUN find /usr/src/app -name "*.py"|xargs chmod +x && find /usr/src/app -name "*.sh"|xargs chmod +x

ENV PATH="/usr/src/app/AnalyzeVacuumUtility:/usr/src/app/ColumnEncodingUtility:/usr/src/app/UnloadCopyUtility:${PATH}"

RUN pip install -r /usr/src/app/requirements.txt && \
    pip install -r /usr/src/app/UnloadCopyUtility/requirements.txt 

ENTRYPOINT ["/usr/src/app/bin/entrypoint.sh"]
