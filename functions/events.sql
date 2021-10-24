CREATE OR REPLACE FUNCTION public.events_messages_trigger()
    RETURNS TRIGGER AS
$$
DECLARE
    event_data events_log;
BEGIN
    SELECT
           public.events_register('MESSAGE_CREATED', NEW.id)
    INTO event_data;

    EXECUTE public.events_dispatch(event_data);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
