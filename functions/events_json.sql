CREATE OR REPLACE FUNCTION public.events_json_encode_message(message messages)
    RETURNS jsonb AS
$$
DECLARE
    chat chats;
    author users;

    author_json jsonb;
BEGIN
  SELECT
      id, repo_name as name, repo_owner
    INTO chat
    FROM chats
    WHERE id = message.chat_id;

  SELECT
        id, username, display_name, avatar_url, flags, bio, country, banner, banner_colour, bot_id
    INTO author
    FROM users
    WHERE id = message.user_id;

  author_json := (SELECT to_jsonb(author) || jsonb_build_object('is_bot', author_json)) - 'bot_id';
  RETURN (SELECT to_jsonb(message) || jsonb_build_object('chat', to_jsonb(chat)) || jsonb_build_object('author', author_json));
END;
$$ LANGUAGE plpgsql;