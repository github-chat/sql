CREATE OR REPLACE FUNCTION public.events_insert_trigger_fnc()
    RETURNS TRIGGER AS
$$
DECLARE
    client_id uuid;
    client    bot_members;
    res       http_client_response;
    message   messages;
BEGIN
    FOR client_id in SELECT public.events_get_clients((NEW.data ->> 'id')::uuid, NEW.event_type)
        LOOP
            SELECT *
            INTO client
            FROM bot_members
            WHERE id = client_id;

            IF NEW.event_type = 'MESSAGE_CREATED' THEN
                SELECT *
                FROM messages
                WHERE id = (NEW.data ->> 'id')::uuid
                INTO message;
                res := public.events_http_send_message_event(NEW.id, NEW.event_type, client, message);
            end if;
            CONTINUE;
        END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;