FROM ubuntu:latest

# 静かに作る
ENV MAKEFLAGS=-s

# 国内で作る
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 材料を持って調理場に移動
COPY ./app/src/ /kitchen/
COPY ./app/Makefile/ /kitchen/
WORKDIR /kitchen/

# 必要なものを用意
RUN apt-get update && \
    apt-get install -y \
    wget \
    ash \
    build-essential \
    gcc \
    g++ \
    ghc \
    gobjc \
    libgnustep-base-dev \
    gnustep \
    gnustep-devel \
    default-jdk \
    sbcl \
    guile-3.0 \
    ocaml \
    nodejs \
    npm \
    curl \
    gnupg \
    erlang \
    elixir \
    && rm -rf /var/lib/apt/lists/*
RUN npm i -g n && \
    n lts
RUN npm i typescript && \
    npm i --save-dev @types/node

# 下準備
RUN gcc c.c        -o c && \
    ghc h.hs       -o h && \
    gcc -lobjc o.m -o o -I/usr/include/GNUstep && \
    g++ c.cpp      -o c-cpp && \
    ocamlc o.ml    -o o-caml && \
    sbcl --eval '(compile-file "l.lisp")' --eval '(quit)' && \
    npx tsc t.ts && \
    chmod +x *
