/*select 'create synonym admwpd.' || table_name 
     || ' for admvfr.' || table_name || ';'
from user_tables  where table_name like 'LWS%'

create synonym admwpd.LWS_COM_RESULTADOS for admvfr.LWS_COM_RESULTADOS;
*/
create synonym wpd.relporprofps for admwpd.relporprofps;
