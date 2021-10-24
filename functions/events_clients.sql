-- Factory to get the correct clients based on event type!
CREATE OR REPLACE FUNCTION public.events_get_clients(event_id uuid, dispatch_event_type event_type)
    RETURNS uuid[] AS
$$
    BEGIN
        IF dispatch_event_type = 'MESSAGE_CREATED' THEN
            -- Get Clients for message created event
            RETURN public.event_get_clients_message(event_id);
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.event_get_clients_message(event_id uuid)
    RETURNS uuid[] AS
$$
    DECLARE
        bots uuid[];
        message messages;
    BEGIN
        -- Get the message
        SELECT id,
               chat_id
            INTO message
            FROM messages
            WHERE id = event_id;

        -- Get the clients that can see that message
        SELECT ARRAY(SELECT id
            INTO bots
            FROM bot_members as bot_member
                WHERE bot_member.chat_id = message.chat_id
                AND bot_member.interactions_url IS NOT NULL);

        return bots;
    END;
$$ LANGUAGE plpgsql;