delete from operacion.opedd o
    where o.descripcion ='WLL/SIAC - CAMBIO DE DECOS'
    AND o.TIPOPEDD = 260;

update operacion.opedd o
     set o.descripcion = 'WLL/SIAC - DES. DECO ADICIONAL'
     where o.descripcion = 'WLL/SIAC - BAJA DECO ALQUILER'
	 and o.abreviacion is null;

update operacion.opedd o
     set o.descripcion = 'WLL/SIAC - ACT. DECO ADICIONAL'
     where o.descripcion = 'WLL/SIAC - CAMBIO DE DECOS'
	 and o.abreviacion is null;
  
COMMIT;