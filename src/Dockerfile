FROM python:3.8-slim-buster
#FROM python:alpine3.7

WORKDIR /app

COPY requirements.txt requirements.txt
#RUN nslookup pypi.org
RUN pip3 install -r requirements.txt

COPY . .

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]

#docker build --network=host  . -t webapp
#docker run -p 5000:5000 -it webapp
#docker run -p 5000:5000 -it webapp
#docker 