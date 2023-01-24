FROM python:slim

COPY . .

CMD ["python3", "server.py"]
