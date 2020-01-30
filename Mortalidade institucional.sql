select distinct round((select count(*) from fapaccad t
  where t.data_alta between '01/03/2015' and '31/03/2015'
  and t.moti_alta = 'O'
  and t.tipo_pac = 'I'
  and t.cod_mot_alta = '07')/(select count(*) from fapaccad t where t.data_alta between '01/03/2015' and '31/03/2015'
  and t.tipo_pac = 'I' and cod_ala <> 'HMDA')*100,2) obito
from fapaccad t
