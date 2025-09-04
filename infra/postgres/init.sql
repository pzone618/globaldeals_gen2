-- PostgreSQL initialization script
-- Author: Tech Lead
-- Date: 2025-09-04

-- Database and user should already be created by environment variables
-- This script is for additional setup if needed

-- Set timezone
SET timezone = 'UTC';

-- Create extensions if needed
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

-- Log initialization
SELECT 'Global Deals database initialized successfully' AS initialization_status;
