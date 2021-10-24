create table if not exists vanities
(
    id            uuid                     default uuid_generate_v4() not null,
    registered_at timestamp with time zone default now()              not null,
    type          integer                                             not null,
    redirect_to   uuid                                                not null,
    text          text                                                not null,
    constraint vanities_pkey
        primary key (id)
);

comment on table vanities is 'Vanity URLs';

comment on column vanities.text is 'The vanity text';

alter table vanities
    owner to supabase_admin;

grant delete, insert, references, select, trigger, truncate, update on vanities to postgres;

grant delete, insert, references, select, trigger, truncate, update on vanities to anon;

grant delete, insert, references, select, trigger, truncate, update on vanities to authenticated;

grant delete, insert, references, select, trigger, truncate, update on vanities to service_role;

