update fapaccad set inibe_pedido = 'N' where tipo_pac = 'E' and conta_fechada is null
and data_ent >= '17/01/2012' and inibe_pedido = 'S'

select * from fapaccad where tipo_pac = 'E' and conta_fechada is null
and data_ent >= '17/01/2012' and inibe_pedido = 'N'
