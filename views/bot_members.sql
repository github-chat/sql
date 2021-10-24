CREATE OR REPLACE VIEW bot_members AS SELECT
    member.id as id,
    member.chat_id as chat_id,
    usr.flags as flags,
    bot.id as bot_id,
    bot.interactions_url as interactions_url
FROM public.members as member
INNER JOIN users usr on usr.id = member.user_id
INNER JOIN bots bot on bot.id = usr.bot_id
WHERE usr.bot_id IS NOT NULL AND bot.interactions_url IS NOT NULL;