FROM postgres

ENV POSTGRES_USER=postgres
# ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=sb_cascade_prod

# Load database from backup file
COPY --chown=postgres:postgres ./docker_test/sb_cascade_e2e.sql /docker-entrypoint-initdb.d/

