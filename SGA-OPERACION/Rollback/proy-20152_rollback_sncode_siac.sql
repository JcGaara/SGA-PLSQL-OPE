delete from operacion.opedd op
      where op.tipopedd in (select a.tipopedd
							  from operacion.tipopedd a
						  	 where a.abrev = 'CONF_SIACSNCOD');
							 
delete from operacion.tipopedd tip
      where	tip.abrev = 'CONF_SIACSNCOD';

delete from operacion.opedd op	  
      where op.tipopedd in (select a.tipopedd
							  from operacion.tipopedd a
						  	 where a.abrev = 'TIP_TRAB_EQU_CHIP');
							 
delete from operacion.tipopedd tip
      where	tip.abrev = 'TIP_TRAB_EQU_CHIP';									 
  
commit;
/

              