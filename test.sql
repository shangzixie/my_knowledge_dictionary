drop schema if exists s1 CASCADE;
create schema s1;
create table s1.t1 (id int, ctx text) distributed by (id);
create table s1.t2 (id int, year int, month int, day int) distributed by (id) partition by range (year) (START (2010) END (2018) EVERY (1), DEFAULT PARTITION other_years);
insert into s1.t2 select id, id, id, id from generate_series(1, 20) id;
insert into s1.t2 select 1, id, id, id from generate_series(1, 20) id;
set optimizer=off;
select *, pg_sleep(0.01) from s1.t2 a join s1.t2 b on a.id = a.id;

