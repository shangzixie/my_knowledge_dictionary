drop schema if exists s1 CASCADE;
create schema s1;
create table s1.t1 (id int, ctx text) distributed by (id);
create table s1.t2 (id int, year int, month int, day int) distributed by (id) partition by range (year) (START (2010) END (2018) EVERY (1), DEFAULT PARTITION other_years);
insert into s1.t2 select id, id, id, id from generate_series(1, 20) id;
insert into s1.t2 select 1, id, id, id from generate_series(1, 20) id;
set optimizer=off;
select *, pg_sleep(0.01) from s1.t2 a join s1.t2 b on a.id = a.id;


INSERT INTO public.avatars (id, created_at, updated_at, deleted_at, name, relationship, visibility, default_brain_id,
                            default_voice_id, default_face_id, creator)
VALUES ('df33fd04-3de6-42ef-9133-63c6c07f6f33', '2023-07-09 15:28:43.219454 +00:00',
        '2023-07-09 15:31:20.780491 +00:00', null, 'laoWang', '', 1, '70e72229-ad44-4591-b25b-50fb3342beab', '',
        '1e75c4b4-3eee-43bf-bbed-85c9638d6285',
        '123456');

INSERT INTO public.brains (id, created_at, updated_at, deleted_at, engine, model, chat_prompt_template,
                           chat_prompt_scene, personality_prompt_template, personality_prompt_scene,
                           memory_prompt_template, memory_prompt_scene, memory_prompt_memory_type, llm_type,
                           importance_rate_prompt_template, policy_prompt_setting, tag, avatar_id)
VALUES ('70e72229-ad44-4591-b25b-50fb3342beab', '2023-07-09 15:28:43.231539 +00:00',
        '2023-07-09 15:28:43.231539 +00:00', null, 1, 'gpt-3.5-turbo', '', '', '', '', '', '', 0, '', '', '', 'Default',
        'df33fd04-3de6-42ef-9133-63c6c07f6f33');


INSERT INTO user (brain_id, scene, language)
VALUES (
    'df33fd04-3de6-42ef-9133-63c6c07f6f33', '2023-07-09 15:28:43.219454 +00:00',
    '2023-07-09 15:31:20.780491 +00:00', null, 'laoWang', '', 1, '70e72229-ad44-4591-b25b-50fb3342beab', '',
    '1e75c4b4-3eee-43bf-bbed-85c9638d6285',
    '123456'
)
ON CONFLICT () DO UPDATE
SET brain_id = "234", scene = 1, language = 1, Template = "123";

