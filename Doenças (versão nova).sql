select * from faprccad where cod_pac in (select cod_pac from fapaccad where tipo_pac = 'U')
and fk_ur_cid is null
select * from urcidcad where pk_ur_cid in
(select fk_ur_cid from faprccad where cod_pac in (select cod_pac from fapaccad where tipo_pac = 'I'))

select t.cod_cid, t.diagnostico, count(t.diagnostico) from urcidcad t, faprccad u
where t.pk_ur_cid = u.fk_ur_cid
and u.cod_pac in (select cod_pac from fapaccad where tipo_pac = 'U')
group by t.cod_cid, t.diagnostico
order by count(t.diagnostico) desc
