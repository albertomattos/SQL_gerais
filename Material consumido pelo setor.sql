select u.tipo_prd from popedite t, faprdcad u where t.cod_prd = u.codigo
and documento in (
select documento from popedcad t where set_con in ('0137','0311','0344','0346','0347','0348','0349','0351','0374','0375','0376',
'0377','0378') and data_mov between '01/07/2012' and '31/07/2012')
order by u.tipo_prd
