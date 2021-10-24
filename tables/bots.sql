create table if not exists bots
(
    id               uuid                                   not null,
    registered_at    timestamp with time zone default now() not null,
    interactions_url text,
    owner_id         uuid                                   not null,
    constraint bots_pkey
        primary key (id),
    constraint bots_id_fkey
        foreign key (id) references users,
    constraint bots_owner_id_fkey
        foreign key (owner_id) references users
);

comment on table bots is 'Bot Account Data';

alter table bots
    owner to supabase_admin;

grant delete, insert, references, select, trigger, truncate, update on bots to postgres;

grant delete, insert, references, select, trigger, truncate, update on bots to anon;

grant delete, insert, references, select, trigger, truncate, update on bots to authenticated;

grant delete, insert, references, select, trigger, truncate, update on bots to service_role;

