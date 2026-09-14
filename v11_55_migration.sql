-- VKTC V11.55
-- Fresh VKTC club registration/settings only.
-- No members, demo users, matches, finance records, or sample data are inserted.
-- Shared global player/OTR tables are left untouched.

begin;

insert into public.clubs(id,code,site_key,name,short_name,active)
values(
  '33333333-3333-4333-8333-333333333333',
  'VKTC',
  'vktc',
  'Victoria Korean Tennis Club',
  'VKTC',
  true
)
on conflict(id) do update
set code=excluded.code,
    site_key=excluded.site_key,
    name=excluded.name,
    short_name=excluded.short_name,
    active=true,
    updated_at=now();

insert into public.club_site_settings(
  club_id,logo_path,hero_path,theme,features,menu_config,updated_at
)
values(
  '33333333-3333-4333-8333-333333333333',
  '/vktc-logo.jpg',
  '/vktc-logo.jpg',
  '{"primary":"#69b9e6","dark":"#17324d","background":"#f4fbff"}'::jsonb,
  '{"season":false,"open_pick":false,"hall_of_fame":false,"accounting":true,"monthly_member_fee":30,"guest_fee":15,"my_page":true,"schedule":false,"upcoming_games":true}'::jsonb,
  '{"home":true,"schedule":true,"mypage":true,"events":true,"ranking":true,"session":true,"draw":true,"accounting":true,"members":true,"settings":true}'::jsonb,
  now()
)
on conflict(club_id) do update
set logo_path=excluded.logo_path,
    hero_path=excluded.hero_path,
    theme=excluded.theme,
    features=excluded.features,
    menu_config=excluded.menu_config,
    updated_at=now();

insert into public.club_admin_invites(club_id,email,role,active)
values(
  '33333333-3333-4333-8333-333333333333',
  'kkjege@hotmail.com',
  'owner',
  true
)
on conflict(club_id,email) do update
set role='owner',active=true;

insert into public.club_admins(club_id,user_id,role,active)
select
  '33333333-3333-4333-8333-333333333333',
  u.id,
  'owner',
  true
from auth.users u
where lower(u.email)=lower('kkjege@hotmail.com')
on conflict(club_id,user_id) do update
set role='owner',active=true;

update public.club_admin_invites i
set claimed_by=u.id,
    claimed_at=coalesce(i.claimed_at,now())
from auth.users u
where i.club_id='33333333-3333-4333-8333-333333333333'
  and lower(i.email)=lower(u.email)
  and lower(i.email)=lower('kkjege@hotmail.com')
  and i.claimed_by is null;

commit;
