SELECT *
  FROM [PrinterSQL].[dbo].[Jobs]
  where SubmitTime between '20/07/2016' and '19/08/2016'
  and StatusPrintText <> ''
  order by NotifyName