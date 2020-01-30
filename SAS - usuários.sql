select t.login, t.name from cmn_users t where t.category in ('1','3') and t.name like 'Derli%' order by 2

select t.* from cmn_users t where t.category in ('1','3') and t.name like 'Derli%' order by 2
--select t.name from cmn_users t where t.category = 3

--select t.* from cmn_users t
