select t.*, t.rowid from cmn_teams t WHERE T.REF_TEAM = '4036'
select t.*, t.rowid from cmn_teams t WHERE T.REF_TEAM in ('3815','3816','3817','3818','3819','3820','3814','4387','3822','3821','3823','4359','3827','3828','3829','3830','3831','3832','3824','4388','3834','3833','3835','4358')

--select * from cmn_users ORDER BY NAME

select t.*, t.rowid from cmn_teams t WHERE T.REF_TEAM in(

select T.REF_TEAM
from bsc_indicators t where t.family = '0' and t.monitor = '1' --(ativos)
--and t.ref_owner = '778'
and upper(t.name) like '%IDENTIFICA%')
