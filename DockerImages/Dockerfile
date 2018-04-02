#FROM ipython/scipyserver
FROM python:3

RUN mkdir -p /usr/src/DockerImages
WORKDIR /usr/src/DockerImages

COPY *.py *.json *.sh  /usr/src/DockerImages/

RUN pip install jupyter notebook
RUN pip install boto3
RUN pip install requests
RUN pip install boto
RUN pip install scipy

RUN pip install numpy
RUN pip install matplotlib
RUN pip install pandas
RUN pip install ipython



ADD run.sh /
RUN chmod +x /run.sh
CMD ["./run.sh"]
ENTRYPOINT ["/run.sh"]
ENTRYPOINT ["python", "datadownload1_1.py"]
