--delete from ticket_medio where data_atual between '01/03/2016' and '31/03/2016';
--Commit;
BEGIN 
   insertTICKET(v_count => '',
               dti => '01/07/2018',
               dtf => '31/07/2018');
END;

select * from ticket_medio
