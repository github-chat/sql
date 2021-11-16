CREATE TABLE IF NOT EXISTS public.users
(
    id              uuid primary key not null default uuid_generate_v4(),
    username        varchar(25)      not null,
    provider_email  text             not null,
    provider_avatar text,

    -- Default Profile Values
    display_name    varchar(25),
    avatar          text,
    bio             varchar(255),
    country         varchar(3),
    banner_colour   varchar(6),
    banner          text,

    -- Flags
    flags           bigint           not null default 0, -- All Flags
    public_flags    bigint           not null default 0, -- Flags Show To Public
    private_flags   bigint           not null default 0, -- Flags Hidden

    -- Premium Info
    premium_type    int2             not null default 0,
    -- TODO add stripe premium info!

    -- Timestamps
    created_at      timestamptz      not null default now(),
    edited_at       timestamptz      not null default now(),
    banned_at       timestamptz
);

CREATE TABLE IF NOT EXISTS public.repositories
(
    id            uuid primary key not null default uuid_generate_v4(),
    name          varchar(25)      not null,
    owner_id      uuid             not null,

    -- Flags
    flags         bigint           not null default 0, -- All Flags
    public_flags  bigint           not null default 0, -- Flags Show To Public
    private_flags bigint           not null default 0, -- Flags Hidden

    -- Timestamps
    created_at    timestamptz      not null default now(),
    edited_at     timestamptz      not null default now(),
    deleted_at    timestamptz
);
ALTER TABLE repositories
    ADD CONSTRAINT fk_repository_owner FOREIGN KEY (owner_id) REFERENCES users (id);

CREATE TABLE IF NOT EXISTS public.chats
(
    id            uuid primary key not null default uuid_generate_v4(),
    repository_id uuid             not null,
    name          varchar(25)      not null,
    type          int4             not null default 0,

    -- Timestamps
    created_at    timestamptz      not null default now(),
    edited_at     timestamptz      not null default now(),
    deleted_at    timestamptz
);
ALTER TABLE chats
    ADD CONSTRAINT fk_chat_repository FOREIGN KEY (repository_id) REFERENCES repositories (id);

CREATE TABLE IF NOT EXISTS public.member_profile
(
    id                  uuid primary key not null default uuid_generate_v4(),
    repository_id       uuid             not null,
    user_id             uuid             not null,

    -- Profile Customisation Values
    nickname            varchar(25),
    avatar              text,
    bio                 varchar(255),
    banner_colour       varchar(6),
    banner              text,

    -- Permissions
    permission_override bigint                    default 0
);
ALTER TABLE member_profile
    ADD CONSTRAINT fk_profile_user FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE member_profile
    ADD CONSTRAINT fk_profile_repo FOREIGN KEY (repository_id) REFERENCES repositories (id);

CREATE TABLE IF NOT EXISTS public.reports
(
    id               uuid primary key not null default uuid_generate_v4(),
    type             int4             not null,
    reporter_id      uuid             not null,
    report_content   jsonb            not null default '{}'::jsonb,

    -- Timestamps
    created_at       timestamptz      not null default now(),
    
    -- Resolved Info
    resolved_at      timestamptz,
    resolved_message text,
    resolved_by      uuid
);
ALTER TABLE reports
    ADD CONSTRAINT fk_reports_user FOREIGN KEY (reporter_id) REFERENCES users (id);
ALTER TABLE reports
    ADD CONSTRAINT fk_reports_resolved_staff FOREIGN KEY (resolved_by) REFERENCES users (id);

CREATE TABLE IF NOT EXISTS public.messages
(
    id                uuid primary key not null default uuid_generate_v4(),
    type              int4                      default 1,
    chat_id           uuid             not null,
    author_id         uuid             not null,
    author_profile_id uuid             not null,
    attachments       jsonb[]          not null default array []::jsonb[],
    mentions          uuid[]           not null default array []::uuid[],
    parent_message    uuid,

    -- Timestamps
    created_at        timestamptz      not null default now(),
    edited_at         timestamptz      not null default now(),
    deleted_at        timestamptz
);
ALTER TABLE messages
    ADD CONSTRAINT fk_messages_chat FOREIGN KEY (chat_id) REFERENCES chats (id);
ALTER TABLE messages
    ADD CONSTRAINT fk_messages_author FOREIGN KEY (author_id) REFERENCES users (id);
ALTER TABLE messages
    ADD CONSTRAINT fk_messages_author_profile FOREIGN KEY (author_profile_id) REFERENCES member_profile (id);

CREATE TABLE IF NOT EXISTS public.vanities
(
    id         uuid primary key not null default uuid_generate_v4(),
    type       int4                      default 1,
    data       jsonb                     default '{}'::jsonb,

    -- Timestamps
    created_at timestamptz      not null default now(),
    edited_at  timestamptz      not null default now()
);