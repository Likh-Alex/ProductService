create table association_value_entry
(
    id                bigint       not null
        primary key,
    association_key   varchar(255) not null,
    association_value varchar(255) null,
    saga_id           varchar(255) not null,
    saga_type         varchar(255) null
);

create index IDXgv5k1v2mh6frxuy5c0hgbau94
    on association_value_entry (saga_id, saga_type);

create index IDXk45eqnxkgd8hpdn6xixn8sgft
    on association_value_entry (saga_type, association_key, association_value);

create table hibernate_sequence
(
    next_val bigint null
);

create table product_read_model
(
    product_id varchar(255)   not null
        primary key,
    name       varchar(255)   null,
    price      decimal(19, 2) null,
    quantity   int            null
);

create table product_write_model
(
    product_id varchar(255)   not null
        primary key,
    name       varchar(255)   null,
    price      decimal(19, 2) null,
    quantity   int            null
);

create table saga_entry
(
    saga_id         varchar(255) not null
        primary key,
    revision        varchar(255) null,
    saga_type       varchar(255) null,
    serialized_saga longblob     null
);

create table token_entry
(
    processor_name varchar(255) not null,
    segment        int          not null,
    owner          varchar(255) null,
    timestamp      varchar(255) not null,
    token          longblob     null,
    token_type     varchar(255) null,
    primary key (processor_name, segment)
);


