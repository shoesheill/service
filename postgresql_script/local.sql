CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE "Users" (
                         "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                         "Name" text,
                         "Email" text,
                         "Address" text,
                         "Phone" text
);

CREATE UNIQUE INDEX ON "Users" ("Id", "Email");

COMMENT ON TABLE "Users" IS 'コレﾃﾌﾞﾙノノット';

-- DROP TABLE "Users" CASCADE;

select  * from "Users";

CREATE  EXTENSION  pglogical;



\dx pglogical

select  * from pglogical.node;

SELECT pglogical.create_node(
               node_name := 'local_node',
               dsn := 'host=192.168.242.94 port=8080 dbname=postgres user=postgres password=postgres'
       );
SELECT pglogical.create_subscription(
               subscription_name := 'sub_remote_to_local',
               provider_dsn := 'host=192.168.242.71 port=8080 dbname=postgres user=postgres
password=postgres',
               replication_sets := '{remote_to_local}'
       );

SELECT pglogical.create_replication_set('local_to_remote');

SELECT pglogical.replication_set_add_table('local_to_remote', 'public."Users"');
SELECT pglogical.replication_set_remove_table(
               set_name := 'local_to_remote',
               relation := 'public."Users"'
       );
SELECT pglogical.replication_set_add_table(
               set_name := 'local_to_remote',
               relation := 'public."Users"',
               synchronize_data := true
       );

SELECT * FROM pglogical.replication_set;

select  * from pglogical.subscription;

SELECT * FROM pg_stat_replication;

insert into "Users" ("Name", "Email", "Address", "Phone")
values ('local_Sushil123','sushil@asec.jp','立花','09054600662');

insert into "Users" ("Name", "Email", "Address", "Phone")
values ('local_827','local827@remote.jp','尼崎','09054600558');
