CREATE OR REPLACE FUNCTION public.events_dispatch(event_data events_log)
    RETURNS VOID AS
$$
DECLARE
    client_id uuid;
    client bot_members;
BEGIN
    FOR client_id in SELECT public.events_get_clients(event_data.id, event_data.event_type) LOOP
        SELECT *
            INTO client
            FROM bot_members
            WHERE id = client_id;
        EXECUTE public.events_dispatch_client(event_data.id, event_data.event_type, event_data.data, client);
        CONTINUE;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.events_dispatch_client(event_id uuid, dispatch_event_type event_type, data_id uuid, client bot_members)
    RETURNS VOID AS
$$
BEGIN
    IF dispatch_event_type = 'MESSAGE_CREATED' THEN
        EXECUTE public.events_dispatch_client_message(event_id, data_id, client);
    end if;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.events_dispatch_client_message(event_id uuid, message_id uuid, client bot_members)
    RETURNS VOID AS
$$
DECLARE
    message messages;
    res http_response;
BEGIN
    SELECT
        *
    INTO message
    FROM messages
    WHERE id = message_id;

    SELECT
           public.events_http_send_message_event(event_id, client, message)
    INTO res;
END;
$$ LANGUAGE plpgsql;