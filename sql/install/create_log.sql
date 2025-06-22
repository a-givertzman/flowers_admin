do $p$
begin
    drop procedure if exists log_info;
    create procedure log_info (s text) language plpgsql as 
    $$
    begin 
        raise notice '%', s;
    end;
    $$;
end
$p$;