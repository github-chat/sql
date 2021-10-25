CREATE OR REPLACE FUNCTION public.events_insert_trigger_fnc()
    RETURNS TRIGGER AS
$$
DECLARE
    client_id uuid;
    client    bot_members;
BEGIN
    FOR client_id in SELECT public.events_get_clients(NEW.id, NEW.event_type)
        LOOP
            SELECT
                   *
                INTO client
                FROM bot_members
                WHERE id = client_id;

            IF NEW.event_type = 'MESSAGE_CREATED' THEN
                EXECUTE public.events_dispatch_message(NEW.id, NEW.data, client);
            end if;
            CONTINUE;
        END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
