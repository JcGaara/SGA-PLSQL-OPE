delete from opedd o
 where o.tipopedd = (select t.TIPOPEDD from TIPOPEDD t where t.ABREV = 'MIGR_SGA_BSCS')
   and o.abreviacion = 'ADIC_TELFIJA';
commit;
