select t.tipo_documento, t.documento, t.data_mov, t.data_dig, t.hra_movimentacao, t.rowid from esmovcad t
where t.documento in ('0061195')
--where t.documento in ('2466826','2451661','2453388','2477731','2485274','2473403','2467832','2461182','2452820','2470817','2455859','2459698','2453034','2452410','2463094','2455691','2476368','2470899','2467488','2484443','2470894','2476391','2479697','2478462')
--and t.tipo_documento = 'REQ'
--select t.*, t.rowid from esmovcad t where t.documento in ('0059603')

/*
SELECT FAPRDCAD.DESCRICAO, G.COD_UNI, G.TIPO_DOCUMENTO, G.DOCUMENTO, G.NOTA, G.COD_SET, G.COD_PRD, G. EST_ANTERIOR, G.QUANT, G.COD_BARRA_INT
FROM FAFECLOG G, FAPRDCAD  WHERE G.COD_PRD = FAPRDCAD.CODIGO/* AND G.TIPO_DOCUMENTO = 'lot'  AND G.COD_UNI IN ('      ')
/*GROUP BY G.COD_UNI,FAPRDCAD.DESCRICAO, G.TIPO_DOCUMENTO, G.DOCUMENTO, G.NOTA, G.COD_SET, G.COD_PRD, G. EST_ANTERIOR,G.QUANT, G.COD_BARRA_INT
order by 3

select t.tipo_documento, t.cod_prd, t.quant, t.valor, t.valor_tot, t.cod_barra_int, t.rowid
from esmovite t where t.documento = '0003569'
and t.tipo_documento = 'BAL'

--select t.tipo_documento, t.documento, t.data_mov, t.data_dig, t.hra_movimentacao, t.rowid from esmovcad t
--where t.documento in ('2447767','2447760','2447753','2447752','2447656','2447627','2447595','2447575','2447548','2447517','2447508','2447499','2447449','2447404','2447358','2447334','2447279','2447264','2447252','2446991','2446825','2446784','2446782','2446770','2446718','2446716','2446697','2446688','2446667','2446665','2446648','2446587','2446534','2446424','2446317','2446241','2446230','2446228','2446047','2446016','2445911','2445907','2445845','2445741','2445662','2445611','2445584','2445461','2445421','2445409','2445390','2445389','2445377','2445372','2445339','2445319','2445252','2445244','2445204','2445090','2445062','2445050','2445045','2444688','2444645','2444643','2444500','2444415','2444394','2444361','2444118','2444109','2443992','2443975','2443973','2443929','2443642','2443638','2443636','2443598','2443574','2443524','2443498','2443415','2443190','2443089','2443077','2443076','2443037','2442978','2427644','2427573','2427487','2427394','2427242','2427200','2427157','2427147','2427108','2426709','2426699','2426659','2426655','2426649','2426647','2426645','2426581','2426459','2426407','2426390','2426385','2426365','2426256','2426172','2426101','2426071','2425077','2425042','2424839','2424825','2424798','2424640','2424527','2424520','2424492','2424437','2424423','2424422','2424421','2424231','2424214','2424213','2420550','2420508','2420490','2419663','2419651','2419586','2419518','2418863','2418801','2418772','2418754','2418627','2418626','2418547','2418536','2418097','2418016','2417853','2438223','2438149','2438148','2438100','2438093','2438009','2437953','2437944','2437937','2437915','2437824','2437817','2437791','2437780','2437724','2437716','2437500','2437494','2437425','2437282','2437264','2437134','2436803','2436161','2436053','2436047','2435926','2435728','2435713','2435693','2435673','2435621','2435610','2434657','2434622','2434546','2433907','2433788','2433781','2432783','2432721','2432719','2432707','2432539','2432518','2432514','2431865','2431808','2431714','2431683','2431640','2431615','2431463','2431438','2430715','2430710','2430632','2430473','2430472','2430393','2430167','2430134','2430086','2430065','2429840','2429834','2429828','2429778','2429056','2428897','2428827','2428820','2428815','2428755','2428750','2428738','2428708','2428674','2428588','2428567','2428543','2428515','2428464','2427716','2427712','2440100','2449517','2448318','2448314','2448288','2425404','2422129','2419670','2419123','2437436','2437429','2437282','2434640','2431820','2431777','2431763','2429183','2429035','2427883','2433605','2440441','2440341','2443185','2426708','2425642','2422483','2420202','2434928','2439828','2439120','2439099','2427563','2427398','2427396','2425780','2425730','2421875','2421834','2437505','2436933','2436914','2436881','2436753','2436730','2436716','2435811','2435758','2423341','2434928','2448914','2448089','2448673','2448592','2447454','2444864','2443270','2450164','2431537','2438949','2438948','2429767','2424481','2428828','2431874','2417516','2435149','2428175','2443089','2417858','2451421','2444207','2444203','2433522','2439887','2448475','2451548','2451510','2451463','2451232','2451022','2451018','2451013','2450929','2450915','2450883','2450782','2450770','2450737','2450695','2450679','2450630','2450570','2450559','2450535','2452058','2452038','2452024','2451978','2451900','2442955','2442888','2442706','2442689','2442605','2442604','2442597','2442502','2442496','2442484','2442477','2442423','2442369','2442324','2442321','2442174','2442015','2441986','2441966','2441957','2441947','2441898','2441878','2441740','2441662','2441608','2441564','2441494','2441435','2441421','2441325','2441324','2441323','2441148','2440943','2440834','2440821','2440794','2440753','2440710','2440693','2440690','2440561','2440537','2440535','2440460','2440370','2440286','2440241','2440183','2440124','2440053','2440042','2440037','2440035','2440026','2440011','2440010','2440005','2439851','2439704','2439677','2439252','2439234','2439227','2439222','2439167','2439068','2439029','2439021','2438890','2438793','2438773','2438676','2438332','2438254','2450272','2450266','2450174','2450131','2450034','2449934','2449895','2449879','2449865','2449557','2449526','2449506','2449350','2449316','2449266','2449224','2449187','2449155','2449122','2449115','2448979','2448953','2448704','2448633','2448542','2448514','2448507','2448494','2448412','2448388','2448367','2448328','2448268','2448117','2448076','2448064','2448062','2448054','2448008','2448006','2447995','2447749','2447731','2447580','2447576','2447539','2447526','2447519','2447427','2447426','2447421','2447412','2447403','2447381','2447331','2447313','2447304','2447296','2447284','2447043','2446876','2446824','2446778','2446732','2446723','2446712','2446686','2446682','2446642','2446634','2446632','2446627','2446611','2446544','2446530','2446477','2446365','2446256','2446187','2446180','2446164','2446052','2445958','2445931','2445733','2445732','2445700','2445574','2445391','2445361','2445357','2445355','2445341','2445329','2445302','2445223','2445215','2445176','2445092','2445063','2445059','2445048','2444628','2444315','2444005','2443811','2443794','2443790','2443604','2443577','2443565','2443438','2443432','2443093','2443072','2442999','2442974','2427612','2427558','2427557','2427517','2427400','2427396','2427388','2427387','2427312','2427301','2427267','2427251','2427201','2427187','2426648','2426561','2426502','2426451','2426383','2426379','2426354','2426349','2426224','2426191','2426128','2426095','2426047','2425121','2424801','2424766','2424739','2424703','2424605','2424602','2424583','2424441','2424269','2424233','2420649','2420555','2420533','2419658','2419605','2419587','2419537','2418808','2418712','2418686','2418666','2418608','2418564','2418542','2418071','2417866','2438218','2438201','2438193','2438172','2438045','2438026','2438013','2437993','2437938','2437905','2437896','2437827','2437801','2437785','2437765','2437764','2437705','2437702','2437695','2437569','2437505','2437437','2437413','2437195','2437050','2437032','2437028','2436903','2436799','2436163','2436118','2436042','2436032','2435811','2435789','2435784','2435684','2435587','2435540','2435498','2435485','2435480','2434886','2434842','2434782','2434695','2434678','2434654','2434538','2433990','2433956','2433939','2433755','2432717','2432628','2432541','2432504','2432458','2432397','2431839','2431827','2431814','2431809','2431806','2431750','2431748','2431680','2431656','2431595','2431507','2431497','2431365','2430701','2430684','2430608','2430592','2430444','2430431','2430428','2430362','2430352','2430346','2430209','2430208','2430175','2430144','2430139','2430075','2430068','2430067','2430054','2429832','2429818','2429773','2428991','2428985','2428889','2428876','2428769','2428741','2428660','2428574','2428532','2428441','2451961','2440107','2449474','2448293','2447384','2447382','2446736','2426618','2426617','2426612','2426610','2425392','2422128','2422053','2417180','2437447','2437051','2437004','2436026','2434758','2434757','2434644','2434608','2431855','2431854','2431778','2431132','2431106','2431086','2428935','2428806','2427788','2427672','2427671','2443220','2443214','2429968','2439098','2439067','2427572','2427335','2426591','2425338','2425319','2421970','2421943','2417113','2436743','2435803','2424390','2421256','2449733','2449449','2451865','2436412','2438074','2442609','2443315','2451014','2442963','2447382','2443599','2442977','2444510','2442812','2438263','2437597','2429767','2438049','2438287','2443494','2443413','2417317')
/*
select t.cod_set, t.cod_prd, t.est_atu, t.cod_barra_int, t.rowid from esestcad t where t.cod_prd in ('000792','001149','000794','214215','000795','213804','000796','000798','214053','213585','000802','219520','000805','214149','000807','000809','000810','000811','000812','000814','000815','214031','000818','216824','000820','214098','213802','213803','000822','213967','000823','215511')
and t.cod_set = '0440' order by 23 desc, 4

select t.*, t.rowid from esestcad t where t.cod_prd in ('209353')
and t.cod_set = '0020' order by 3 desc, 4

select t.*, t.rowid from eshiscad t where t.cod_prd in ('204042') and t.ano_mes = '201501'
select t.*, t.rowid from eshiscad t where t.est_atu_mes < 0

select t.*, t.rowid from esprod_set_lote t where --t.cod_prd  in ('223482')--t.data_hora_inc between '28/08/2014' and '29/08/2014'
t.cod_set = '0015' and t.cod_prd = '009512' in ('007107','008550','223482','009132','204073','204042','009458','009465','009520','009537','008811','001795','002429')
*/
