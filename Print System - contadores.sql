/****** Script do comando SelectTopNRows de SSMS  ******/
SELECT [sPrinterId],[SerialNumber],[Cont_Geral],[Data],[sPrinterNome]
  FROM [PrinterSQL].[dbo].[SNMP_History]
  where Data > '19/09/2016'
  --and sPrinterId = '141'
  order by sPrinterId, Data