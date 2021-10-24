DROP TRIGGER IF EXISTS message_insert_bot_trigger on public.messages;

CREATE TRIGGER
  message_insert_bot_trigger
  AFTER INSERT ON public.messages
  FOR EACH ROW
  EXECUTE PROCEDURE
    public.events_messages_trigger();