DROP TRIGGER IF EXISTS event_insert_trigger on public.events_log;

CREATE TRIGGER
    event_insert_trigger
    AFTER INSERT
    ON public.events_log
    FOR EACH ROW
EXECUTE PROCEDURE
    public.events_insert_trigger_fnc();