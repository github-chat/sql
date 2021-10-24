create table if not exists users
(
    id            uuid                     default uuid_generate_v4()        not null,
    created_at    timestamp with time zone default now()                     not null,
    username      text,
    avatar_url    text,
    flags         bigint                   default '0'::bigint               not null,
    bio           text,
    display_name  varchar,
    country       varchar,
    banner        uuid,
    banner_colour varchar                  default '#FFF'::character varying not null,
    bot_id        uuid,
    constraint users_pkey
        primary key (id),
    constraint users_username_key
        unique (username),
    constraint users_bot_id_key
        unique (bot_id),
    constraint users_bot_id_fkey
        foreign key (bot_id) references bots
);

comment on column users.banner_colour is 'The colour to be shown when no banner is available';

comment on column users.bot_id is 'Bot Account, if applicable';

alter table users
    owner to supabase_admin;

grant delete, insert, references, select, trigger, truncate, update on users to postgres;

grant delete, insert, references, select, trigger, truncate, update on users to anon;

grant delete, insert, references, select, trigger, truncate, update on users to authenticated;

grant delete, insert, references, select, trigger, truncate, update on users to service_role;

