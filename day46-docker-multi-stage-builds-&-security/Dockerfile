FROM python:3.12-slim AS builder
ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
WORKDIR /src
COPY app/requirements.txt .
RUN pip install --upgrade pip && pip wheel --no-cache-dir --no-deps -r requirements.txt -w /wheels
COPY app /src
RUN pip install --no-cache-dir --no-deps /wheels/*

FROM python:3.12-slim AS runtime
RUN useradd -u 10001 -m appuser
ENV VIRTUAL_ENV=/opt/venv
COPY --from=builder /opt/venv /opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
WORKDIR /app
COPY app /app
EXPOSE 8080
USER 10001
HEALTHCHECK --interval=30s --timeout=3s CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/health')" || exit 1
CMD ["python","main.py"]
