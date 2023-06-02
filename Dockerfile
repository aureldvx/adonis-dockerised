FROM node:20

RUN corepack enable; \
    npm install -g npm@latest;
