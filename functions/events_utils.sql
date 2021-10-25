CREATE OR REPLACE FUNCTION public.events_init()
    RETURNS void AS
$$
BEGIN
    CREATE TYPE public.event_type AS ENUM ('MESSAGE_CREATED');
    CREATE TABLE IF NOT EXISTS public.events_log
    (
        id                   uuid                     default uuid_generate_v4() primary key not null,
        event_type           public.event_type                                               not null,
        created_at           timestamp with time zone default now()                          not null,
        executed             bool                     default false                          not null,
        num_clients_received int8                     default 0                              not null,
        data                 jsonb                    default '{}'::jsonb                                                            not null
    );
    CREATE TYPE http_client_response AS
    (
        status       integer,
        content_type varchar,
        data         jsonb,
        type         integer
    );
END;
$$ LANGUAGE plpgsql;