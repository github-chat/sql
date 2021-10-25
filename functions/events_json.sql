CREATE OR REPLACE FUNCTION public.events_json_encode_message(message messages)
    RETURNS jsonb AS
$$
DECLARE
    chat chats;
    author users;

    author_json jsonb;
BEGIN
  SELECT
      *
    INTO chat
    FROM chats
    WHERE id = message.chat_id;

  SELECT
        *
    INTO author
    FROM users
    WHERE id = message.user_id;

  author_json := (SELECT to_jsonb(author) || jsonb_build_object('is_bot', author.bot_id IS NOT NULL)) - 'bot_id';
  RETURN (SELECT to_jsonb(message) || jsonb_build_object('chat', to_jsonb(chat)) || jsonb_build_object('author', author_json));
END;
$$ LANGUAGE plpgsql;