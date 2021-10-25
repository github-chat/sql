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
    EXECUTE public.events_register('MESSAGE_CREATED', NEW.id);

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
