 insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
  values ((select max(TIPOPEDD) + 1 from tipopedd), 'Cambia Direccion TE', 'CAMBIO_DIRECCION_TE');
      
  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values ((select max(IDOPEDD) + 1 from opedd), null,693,
  'HFC/SIAC - TRASLADO EXTERNO', 'TRASLADO_EXTERNO_HFC',(select MAX(tipopedd) from tipopedd where upper(abrev)='CAMBIO_DIRECCION_TE'),1);
      

commit;
/