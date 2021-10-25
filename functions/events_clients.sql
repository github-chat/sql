-- Factory to get the correct clients based on event type!
CREATE OR REPLACE FUNCTION public.events_get_clients(data_id uuid, dispatch_event_type event_type)
    RETURNS uuid[] AS
$$
DECLARE
    clients uuid[];
BEGIN
    IF dispatch_event_type = 'MESSAGE_CREATED' THEN
        -- Get Clients for message created event
        -- Get the clients that can see that message
        SELECT ARRAY(SELECT id
                     FROM bot_members as bot_member
                     WHERE bot_member.chat_id = (SELECT chat_id
                                                 FROM messages
                                                 WHERE id = data_id)
                       AND bot_member.interactions_url IS NOT NULL)
        INTO clients;
    END IF;

    RETURN clients;
END;
$$ LANGUAGE plpgsql;