create or replace procedure Cancela_pedidos_lab is
begin
execute immediate 'update itens_ped_proced set dh_canc_pedido = sysdate - 1
  where num_pedido in (select a.num_pedido from itens_ped_proced a where a.num_pedido in
  (select f.Num_Pedido from  ITENS_PED_PROCED f, faprdcad h, pedidos_proced g
  where f.cod_prd = h.codigo and f.num_pedido = g.num_pedido
  and f.num_pedido in (select distinct g.num_pedido
  from pedidos_proced g, itens_ped_proced i, faprdcad j where g.num_pedido = i.num_pedido
  and i.cod_prd = j.codigo and i.confirmado = ''N'' and i.dh_canc_pedido is null and i.comanda IS NULL
  and j.tipo_prd = ''LAB'' and g.cod_pac in (select cod_pac from fapaccad where tipo_pac = ''I''))
  and h.tipo_prd = ''LAB'' and f.confirmado = ''N'' and g.cod_pac in 
  (select cod_pac from fapaccad where tipo_pac = ''I'') and g.data_hora <= sysdate - 2 and f.comanda IS NULL)
  and a.confirmado = ''N'' and a.cod_prd in (select codigo from faprdcad where tipo_prd = ''LAB'')
  and a.comanda IS NULL) and cod_prd in (select codigo from faprdcad where tipo_prd = ''LAB''
  and comanda IS NULL and confirmado = ''N'')';
  commit;
end Cancela_pedidos_lab;
/
