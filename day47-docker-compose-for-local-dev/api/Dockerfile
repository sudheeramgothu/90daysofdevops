FROM python:3.12-slim
RUN useradd -u 10001 -m appuser
WORKDIR /app
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r /app/requirements.txt
COPY app.py /app/app.py
COPY main.py /app/main.py
EXPOSE 8080
USER 10001
CMD ["python","main.py"]
