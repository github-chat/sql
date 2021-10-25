CREATE OR REPLACE FUNCTION public.events_dispatch_message(event_id uuid, dispatch_event_type event_type, message_id uuid, client bot_members)
    RETURNS VOID AS
$$
DECLARE
    message messages;
    res http_client_response;
BEGIN
    SELECT
        *
    INTO message
    FROM messages
    WHERE id = message_id;

    SELECT
           public.events_http_send_message_event(event_id, dispatch_event_type, client, message)
    INTO res;
END;
$$ LANGUAGE plpgsql;