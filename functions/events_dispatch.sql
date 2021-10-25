CREATE OR REPLACE FUNCTION public.events_dispatch_message(event_id uuid, message_id uuid, client bot_members)
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