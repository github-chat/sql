create table if not exists chats
(
    id                    uuid                     default uuid_generate_v4() not null,
    created_at            timestamp with time zone default now()              not null,
    github_repo_id        bigint                                              not null,
    repo_owner            varchar                                             not null,
    repo_name             varchar                                             not null,
    repo_description      text,
    repo_data_last_update timestamp with time zone default now()              not null,
    repo_owner_avatar     text,
    constraint chats_pkey
        primary key (id),
    constraint chats_github_repo_id_key
        unique (github_repo_id)
);

alter table chats
    owner to supabase_admin;

grant delete, insert, references, select, trigger, truncate, update on chats to postgres;

grant delete, insert, references, select, trigger, truncate, update on chats to anon;

grant delete, insert, references, select, trigger, truncate, update on chats to authenticated;

grant delete, insert, references, select, trigger, truncate, update on chats to service_role;

