create table if not exists members
(
    id          uuid                     default uuid_generate_v4() not null,
    joined_at   timestamp with time zone default now()              not null,
    user_id     uuid                                                not null,
    chat_id     uuid                                                not null,
    nickname    varchar,
    typing      boolean                  default false              not null,
    permissions bigint                   default '0'::bigint        not null,
    constraint members_pkey
        primary key (id),
    constraint members_chat_id_fkey
        foreign key (chat_id) references chats,
    constraint members_user_id_fkey
        foreign key (user_id) references users
);

alter table members
    owner to supabase_admin;

create unique index if not exists members_unique
    on members (user_id, chat_id);

grant delete, insert, references, select, trigger, truncate, update on members to postgres;

grant delete, insert, references, select, trigger, truncate, update on members to anon;

grant delete, insert, references, select, trigger, truncate, update on members to authenticated;

grant delete, insert, references, select, trigger, truncate, update on members to service_role;

