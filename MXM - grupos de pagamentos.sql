select fgi_codfor, gpa_dsgrupo from FGPAGIR_FGI, grpag_gpa
where gpa_cdgrupo = fgi_codgrpag
and (gpa_ctbgrupo like '115%' or gpa_ctbgrupo like '132%')
and fgi_codfor like '00202%'
order by fgi_codfor

select * from FGPAGIR_FGI order by fgi_codmoeda