-- CONFIGURACION 

 insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
  values ((select max(TIPOPEDD) + 1 from tipopedd), 'WLL/SIAC PUNTOS ADICIONALES', 'PUNTOS_ADICIONALES_WLL_SIAC');
  
  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values ((select max(IDOPEDD) + 1 from opedd), 'LTE',(SELECT tiptra FROM tiptrabajo WHERE descripcion ='WLL/SIAC PUNTOS ADICIONALES'),
  'WLL/SIAC – PUNTOS ADICIONALES', 'PUNTOS_ADICIONALES_WLL_SIAC',(select MAX(tipopedd) from tipopedd where upper(abrev)='PUNTOS_ADICIONALES_WLL_SIAC'),
  NULL);           
/


