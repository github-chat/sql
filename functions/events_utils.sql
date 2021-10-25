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

-- CREATE OR REPLACE FUNCTION public.events_register(new_event_type public.event_type, new_event_data uuid)
--     RETURNS events_log AS
-- $$
-- DECLARE
--     event_data events_log;
-- BEGIN
--     INSERT INTO public.events_log (event_type, data)
--     VALUES (new_event_type, new_event_data)
--     RETURNING * INTO event_data;
--
--     RETURN event_data;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE OR REPLACE FUNCTION public.events_get_event(event_id uuid)
--     RETURNS events_log AS
-- $$
-- DECLARE
--     event events_log;
-- BEGIN
--     SELECT * INTO event FROM public.events_log as e WHERE e.id = event_id;
--     return event;
-- END;
-- $$ LANGUAGE plpgsql;