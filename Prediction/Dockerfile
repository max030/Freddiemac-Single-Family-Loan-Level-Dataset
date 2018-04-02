# our R base image
FROM r-base


COPY *.R *.txt *.sh  /usr/src/Prediction/
WORKDIR /usr/src/Prediction

CMD ["Rscript", "Prediction.R"]

RUN mkdir -p /usr/src/Prediction


ADD run.sh /
#RUN chmod +x /run.sh
CMD ["./run.sh"]
ENTRYPOINT ["/run.sh"]
ENTRYPOINT ["Rscript", "Prediction.R"]
