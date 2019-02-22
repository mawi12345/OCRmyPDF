FROM alpine:3.9 as base

FROM base as builder

RUN \
  echo '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
  # Add runtime dependencies
  && apk add --update \
    python3-dev \
    py3-setuptools \
    jbig2enc@testing \
    ghostscript \
    qpdf \
    tesseract-ocr \
    unpaper \
    pngquant \
    libxml2-dev \
    libxslt-dev \
    zlib-dev \
    qpdf-dev \
    libffi-dev \
    leptonica-dev \
    binutils \
  # Install pybind11 for pikepdf
  && pip3 install pybind11 \
  # Add build dependencies
  && apk add --virtual build-dependencies \
    build-base \
    git

COPY . /app

WORKDIR /app

RUN pip3 install .

FROM base

RUN \
  echo '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
  # Add runtime dependencies
  && apk add --update \
    python3 \
    jbig2enc@testing \
    ghostscript \
    qpdf \
    tesseract-ocr \
    unpaper \
    pngquant \
    libxml2 \
    libxslt \
    zlib \
    qpdf \
    libffi \
    leptonica-dev \
    binutils

COPY --from=builder /usr/lib/python3.6/site-packages /usr/lib/python3.6/site-packages
COPY --from=builder /usr/bin/ocrmypdf /usr/bin/dumppdf.py /usr/bin/latin2ascii.py /usr/bin/pdf2txt.py /usr/bin/img2pdf /usr/bin/chardetect /usr/bin/

ENTRYPOINT ["/usr/bin/ocrmypdf"]
