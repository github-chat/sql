create table if not exists messages
(
    id             uuid                     default uuid_generate_v4() not null,
    chat_id        uuid                                                not null,
    user_id        uuid                                                not null,
    type           integer                  default 1                  not null,
    content        text,
    mentions       uuid[],
    parent_message uuid,
    edited_at      timestamp with time zone,
    created_at     timestamp with time zone default now()              not null,
    files          jsonb[],
    constraint messages_pkey
        primary key (id),
    constraint messages_chat_id_fkey
        foreign key (chat_id) references chats,
    constraint messages_parent_message_fkey
        foreign key (parent_message) references messages,
    constraint messages_user_id_fkey
        foreign key (user_id) references users
);

comment on column messages.files is 'v2 Files Support';

alter table messages
    owner to supabase_admin;

grant delete, insert, references, select, trigger, truncate, update on messages to postgres;

grant delete, insert, references, select, trigger, truncate, update on messages to anon;

grant delete, insert, references, select, trigger, truncate, update on messages to authenticated;

grant delete, insert, references, select, trigger, truncate, update on messages to service_role;

