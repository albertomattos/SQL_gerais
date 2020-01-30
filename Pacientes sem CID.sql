update faprccad set cid = "J10" where cid = "" and principal = "S" and data_real >= "01/09/2007"

select cod_con,remessa, faprccad.* from faprccad, fafatcad where faprccad.cod_pac = fafatcad.cod_pac
and fafatcad.remessa = "043875"
and principal = "S"
and (cid is null or cid = "")

select * from fafatcad where remessa = "043042" and cod_pac not in (
select faprccad.cod_pac from faprccad, fafatcad where faprccad.cod_pac = fafatcad.cod_pac
and fafatcad.remessa = "043623"
and principal = "S")

SELECT fafatcad.cod_con, fafatcad.remessa,
       faprccad.cid, faprccad.cod_pac
FROM fafatcad fafatcad, faprccad faprccad
WHERE (faprccad.cod_pac = fafatcad.cod_pac) AND (
      ( faprccad.principal = 'S' )
       AND ( faprccad.cid IS NULL  ))
       and remessa = "043875"
