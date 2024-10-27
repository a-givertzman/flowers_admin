do $$
begin
    if not exists (SELECT 1 FROM pg_user WHERE usename = 'flowers_app') THEN
        CREATE USER "flowers_app" WITH PASSWORD '00d0-25e4-*&s2-ccds' CREATEDB CREATEROLE;
    end if;
    if exists (SELECT 1 FROM pg_database WHERE datname = 'flowers_app') THEN
        if exists (SELECT 1 FROM pg_roles WHERE rolname = 'flowers_app') then
            GRANT ALL PRIVILEGES ON DATABASE "flowers_app" TO "flowers_app";
            GRANT ALL ON SCHEMA public TO "flowers_app";
            GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "flowers_app";
            ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO "flowers_app";
            ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO "flowers_app";
            ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON FUNCTIONS TO "flowers_app";
        end if;
    end if;
end
$$;