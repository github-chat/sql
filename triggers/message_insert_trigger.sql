CREATE OR REPLACE FUNCTION
    public.message_insert_trigger_fnc()
    RETURNS TRIGGER AS
$$
BEGIN
    -- Register Member
    IF NOT EXISTS(SELECT 1 FROM members m WHERE m.user_id = NEW.user_id) THEN
        INSERT INTO public.members (user_id, chat_id) VALUES (NEW.user_id, NEW.chat_id);
    END IF;

    -- Register Event For Bots!
    INSERT INTO public.events_log (event_type, data)
    VALUES ('MESSAGE_CREATED', ('{"id": "' || NEW.id || '"}')::jsonb);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS message_insert_trigger on public.messages;

CREATE TRIGGER
    message_insert_trigger
    AFTER INSERT
    ON public.messages
    FOR EACH ROW
EXECUTE PROCEDURE
    public.message_insert_trigger_fnc();
