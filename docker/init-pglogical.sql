-- Initialize pglogical extension
-- This script runs automatically when the PostgreSQL container starts

-- Create the pglogical extension
CREATE EXTENSION IF NOT EXISTS pglogical;

-- Log the installation
DO $$
BEGIN
    RAISE NOTICE 'pglogical extension installed successfully';
END $$;
