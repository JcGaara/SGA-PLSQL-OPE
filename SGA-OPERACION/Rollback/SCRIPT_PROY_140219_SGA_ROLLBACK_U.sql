
delete from opedd o
 where o.tipopedd in (select t.tipopedd
                        from tipopedd t
                       where t.abrev = 'TIPREGCONTIWSGABSCS')
   and o.codigon = 814;
commit;