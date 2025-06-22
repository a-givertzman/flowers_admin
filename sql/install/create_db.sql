SELECT 'CREATE DATABASE flowers_app'
        WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'flowers_app')\gexec