FROM docker-registry.mitre.org:8443/node:16.14.2 AS prod-deps

# Set ENV Variables
ENV NPM_CONFIG_LOGLEVEL warn

# Add Additional Certs
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -skL 'https://gitlab.mitre.org/mitre-scripts/mitre-pki/raw/master/os_scripts/install_certs.sh' | bash
RUN curl -skL 'http://pki.mitre.org/MITRE-chain.txt' -o /etc/ssl/certs/mitre-chain.pem

WORKDIR /src

# Copy in all project files
COPY ./package*.json ./

# Install only prod dependencies
RUN npm ci --only=prod

FROM prod-deps AS build-env

# Install ALL node_modules, including devDependencies
RUN npm install

COPY . .

# Run linter
#RUN npm run lint

# Create Logs Directory
#RUN mkdir -p /var/log/projectpages-api \
 # && mkdir -p /data/projectpages-api/static \
 # && mkdir -p /apps/webapps/projectpages-api/static

# ---- Release ----
FROM gcr.io/distroless/nodejs:16

#LABEL mitre.name=projectpages-api
#LABEL mitre.project=projectpages-api
#LABEL mitre.maintainer=r501-team3d@groups.mitre.org

# Set ENV Variables
ENV TZ America/New_York
ENV NODE_EXTRA_CA_CERTS /etc/ssl/certs/ca-certificates.crt

WORKDIR /app

# Copy source files and certs
#COPY --from=build-env /src/app .
COPY --from=prod-deps /src/node_modules ./node_modules
COPY --from=build-env /etc/ssl/certs /etc/ssl/certs
#COPY --from=build-env /var/log/projectpages-api /var/log/projectpages-api
#COPY --from=build-env /data/projectpages-api/static /data/projectpages-api/static

EXPOSE 9002

CMD /bin/bash
