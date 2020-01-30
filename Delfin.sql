SELECT cod_ala,'fapacpro',count(*) FROM fapacpro where cod_ala = 'DELF' GROUP BY 1,2 ORDER BY 1,2
update faalacad set cod_ala = "IMAG" where cod_ala = "DELF"
select * from vw_fath_fapacdth where cod_ala = "DELF"

SELECT cod_ala,'imatecad',count(*) FROM imatecad where cod_ala = 'DELF' GROUP BY 1,2 ORDER BY 1,2
SELECT cod_ala,'fapaccad',count(*) FROM fapaccad where cod_ala = 'DELF' GROUP BY 1,2 ORDER BY 1,2
SELECT cod_ala,'imagncad',count(*) FROM imagncad where cod_ala = 'DELF' GROUP BY 1,2 ORDER BY 1,2
SELECT cod_ala,'clinica_espec',count(*) FROM clinica_espec where cod_ala = 'DELF' GROUP BY 1,2 ORDER BY 1,2
SELECT cod_ala,'vw_fath_fapacdth',count(*) FROM vw_fath_fapacdth where cod_ala = 'DELF' GROUP BY 1,2 ORDER BY 1,2
SELECT cod_ala,'hs_setorala',count(*) FROM hs_setorala where cod_ala = 'DELF' GROUP BY 1,2 ORDER BY 1,2

