do $$
declare 
    result record;
begin
    if not exists (SELECT 1 FROM pg_user WHERE usename = 'flowers_app') THEN
        CREATE USER "flowers_app" WITH PASSWORD '00d0-25e4-*&s2-ccds' CREATEDB CREATEROLE;
        call log_info('User "flowers_app" created');
    else
        call log_info('User "flowers_app" already exists');
    end if;
    if exists (SELECT 1 FROM pg_database WHERE datname = 'flowers_app') THEN
        call log_info('\tDatabase "flowers_app" found,');
        if exists (SELECT 1 FROM pg_roles WHERE rolname = 'flowers_app') then
            call log_info('\tUser "flowers_app" found, granting privileges...');
            -- call log_info('GRANT ALL PRIVILEGES ON DATABASE "flowers_app" TO "flowers_app"...');
            GRANT ALL PRIVILEGES ON DATABASE "flowers_app" TO "flowers_app";
            -- call log_info('GRANT ALL ON SCHEMA public TO "flowers_app"...');
            GRANT ALL ON SCHEMA public TO "flowers_app";
            GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "flowers_app";
            ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO "flowers_app";
            ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO "flowers_app";
            ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON FUNCTIONS TO "flowers_app";
        end if;
    end if;
end
$$ LANGUAGE plpgsql;