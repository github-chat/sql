CREATE OR REPLACE VIEW public.p_Users AS
SELECT u.id              as id,
       u.username        as username,
       u.provider_avatar as provider_avatar,
       u.display_name    as display_name,
       u.avatar          as avatar,
       u.bio             as bio,
       u.country         as country,
       u.banner_colour   as banner_colour,
       u.banner          as banner,
       u.public_flags    as flags,
       u.created_at      as created_at,
       u.edited_at       as edited_at
FROM public.users u
WHERE u.banned_at IS NULL;

CREATE OR REPLACE VIEW public.p_Profiles AS
SELECT p.id                  as id,
       u.id                  as user_id,
       p.repository_id       as repository_id,
       u.username            as username,
       u.avatar              as avatar,
       u.provider_avatar     as provider_avatar,
       u.bio                 as bio,
       u.banner_colour       as banner_colour,
       u.banner              as banner,
       u.country             as country,
       p.nickname            as repository_nickname,
       p.avatar              as repository_avatar,
       p.bio                 as repository_bio,
       p.banner_colour       as repository_banner_colour,
       p.banner              as repository_banner,
       p.permission_override as permission_override,
       u.flags               as flags,
       p.created_at          as joined_at,
       p.edited_at           as edited_at,
       p.banned_at           as banned_at
FROM public.member_profile p
         INNER JOIN public.p_Users u on u.id = p.user_id
WHERE p.deleted_at IS NULL;

CREATE OR REPLACE VIEW public.p_Repositories AS
SELECT r.id           as id,
       r.name         as name,
       r.owner_id     as owner_id,
       u.username     as owner_name,
       r.public_flags as flags,
       r.created_at   as created_at,
       r.edited_at    as edited_at
FROM public.repositories r
         INNER JOIN public.p_Users u on u.id = r.owner_id
WHERE r.deleted_at IS NULL;

CREATE OR REPLACE VIEW public.p_Chats AS
SELECT c.id            as id,
       c.repository_id as repository_id,
       c.name          as name,
       c.type          as type,
       c.created_at    as created_at,
       c.edited_at     as edited_at
FROM public.chats c
WHERE c.deleted_at IS NULL;

CREATE OR REPLACE VIEW public.p_Messages as
SELECT m.id                as id,
       m.type              as type,
       m.chat_id           as chat_id,
       c.name              as chat_name,
       r.id                as repository_id,
       r.name              as repository_name,
       m.author_profile_id as author_profile_id,
       m.content           as content,
       m.attachments       as attachements,
       m.mentions          as mentions,
       m.parent_message    as parent_message_id,
       m.created_at        as created_at,
       m.edited_at         as edited_at
FROM public.messages m
         INNER JOIN public.p_Chats c on m.chat_id = c.id
         INNER JOIN public.p_Repositories r on c.repository_id = r.id
WHERE m.deleted_at IS NULL;

CREATE OR REPLACE VIEW public.p_Vanities AS
SELECT v.id         as id,
       v.type       as type,
       v.data       as data,
       v.created_at as created_at,
       v.edited_at  as edited_at
FROM public.vanities v;

CREATE OR REPLACE VIEW public.p_UserVanities AS
SELECT *
FROM public.p_Vanities v
WHERE v.type = 1;

CREATE OR REPLACE VIEW public.p_RepositoryVanities AS
SELECT *
FROM public.p_Vanities v
WHERE v.type = 2;

CREATE OR REPLACE VIEW public.p_Reports AS
SELECT r.id              as id,
       r.type            as type,
       r.reporter_id     as reporter_id,
       r.resolved_at     as resolved_at,
       r.resolved_by     as resolved_by_id,
       u.username        as resolved_by_username,
       u.avatar          as resolved_by_avatar,
       u.provider_avatar as resolved_by_provider_avatar
FROM public.reports r
         INNER JOIN public.p_Users u on r.resolved_by = u.id;