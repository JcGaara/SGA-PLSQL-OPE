DELETE FROM OPERACION.OPEDD WHERE TIPOPEDD = (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'PENALIDAD_TIPEQU');
DELETE FROM OPERACION.TIPOPEDD WHERE ABREV = 'PENALIDAD_TIPEQU';
	
update operacion.opedd o
     set o.abreviacion ='WLL/SIAC - DES. DECO ADICIONAL',
     o.descripcion = 'WLL/SIAC - DES. DECO ADICIONAL'
     where idopedd = (select idopedd from operacion.opedd  where abreviacion ='WLL/SIAC - BAJA DECO ALQUILER');
     
update operacion.opedd o
     set o.abreviacion ='WLL/SIAC - ACT. DECO ADICIONAL',
      o.descripcion = 'WLL/SIAC - ACT. DECO ADICIONAL'
     where idopedd = (select idopedd from operacion.opedd  where abreviacion ='WLL/SIAC - CAMBIO DE DECOS');
	 
update operacion.tiptrabajo set descripcion='WLL/SIAC - DES. DECO ADICIONAL' 
    where tiptra = (select tiptra from operacion.tiptrabajo where descripcion='WLL/SIAC - BAJA DECO ALQUILER');
	
update operacion.tiptrabajo set descripcion='WLL/SIAC - ACT. DECO ADICIONAL' 
    where tiptra = (select tiptra from operacion.tiptrabajo where descripcion='WLL/SIAC - CAMBIO DE DECOS');
	 
delete from operacion.tiptraventana where tiptra = 756 and idventana = 42;

commit;