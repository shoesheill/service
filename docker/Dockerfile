# Use official PostgreSQL 17 image
FROM postgres:17

# Install pglogical
RUN apt-get update && apt-get install -y \
    postgresql-17-pglogical \
    && rm -rf /var/lib/apt/lists/*

# Expose PostgreSQL port
EXPOSE 5432


# Copy initialization script
COPY ./init-pglogical.sql /docker-entrypoint-initdb.d/
