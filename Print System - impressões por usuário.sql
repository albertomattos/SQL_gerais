--Cópias por usuário
SELECT a.NotifyName usuario, sum(a.TotalPages) copias
  FROM [PrinterSQL].[dbo].[Jobs] a, [PrinterSQL].[dbo].[Printers] b
  where a.PrinterID = b.PrinterID
  and a.SubmitTime between '01/05/2017' and '31/05/2017'
  and a.StatusPrintText = ''
  group by a.NotifyName
  order by NotifyName


SELECT b.PrinterName, b.PrinterKey, a.NotifyName usuario, sum(a.TotalPages) copias
  FROM [PrinterSQL].[dbo].[Jobs] a, [PrinterSQL].[dbo].[Printers] b
  where a.PrinterID = b.PrinterID
  and a.SubmitTime between '20/01/2017' and '19/02/2017'
  and a.StatusPrintText = ''
  --and a.PrinterID in ('177','139','163','186','137','500')
  --and NotifyName = 'adiele.freitas'
  group by b.PrinterName, b.printerkey, a.NotifyName, a.Document, a.SubmitTime
  order by NotifyName

SELECT PrinterID, Document documento, SubmitTime, sum(TotalPages) copias
--SELECT *
  FROM [PrinterSQL].[dbo].[Jobs]
  where SubmitTime between '03/08/2016' and '04/08/2016'
  and StatusPrintText = ''
  --and PrinterID in ('140','426')
  --and NotifyName like '%ence%'
  group by PrinterID, Document, SubmitTime
  order by PrinterID
  
  --Impressoras e serial number
  select c.PrinterName, c.SerialNumber
from PrinterSQL.dbo.SPrinters c