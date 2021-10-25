CREATE OR REPLACE FUNCTION public.events_insert_trigger_fnc()
    RETURNS TRIGGER AS
$$
DECLARE
    client_id uuid;
    client    bot_members;
    res       http_client_response;
BEGIN
    FOR client_id in SELECT public.events_get_clients((NEW.data ->> 'id')::uuid, NEW.event_type)
        LOOP
            SELECT *
            INTO client
            FROM bot_members
            WHERE id = client_id;

            IF NEW.event_type = 'MESSAGE_CREATED' THEN
                DECLARE
                    message messages;
                BEGIN
                    SELECT *
                    FROM messages
                    WHERE id = (NEW.data ->> 'id')::uuid
                    INTO message;
                    res := public.events_http_send_message_event(NEW.id, NEW.event_type, client, message);
                    IF res.type = 1 THEN
                        IF res.data->>'content' IS NOT NULL THEN
                            INSERT INTO public.messages (chat_id, user_id, parent_message, content)
                            VALUES (message.chat_id, client.bot_user_id, message.id, res.data->>'content');
                        end if;
                    end if;
                end;
            end if;
            CONTINUE;
        END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;