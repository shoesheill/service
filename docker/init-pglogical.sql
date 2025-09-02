-- Initialize PostgreSQL extensions
-- This script runs automatically when the PostgreSQL container starts

-- Create the pglogical extension
CREATE EXTENSION IF NOT EXISTS pglogical;

-- Create the pgcrypto extension
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Log the installation
DO $$
BEGIN
    RAISE NOTICE 'pglogical and pgcrypto extensions installed successfully';
END $$;
