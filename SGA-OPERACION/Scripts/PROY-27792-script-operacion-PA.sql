   
-- Insertar configuracion
 insert into operacion.tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
  values ((select max(TIPOPEDD) + 1 from operacion.tipopedd), 'TIPTRA COBRO OCC', 'REMARK_COBRO_OCC');
      
  insert into operacion.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values ((select max(IDOPEDD) + 1 from operacion.opedd), 'HFC/SIAC - PUNTO ADICIONAL',700,'Cobro OCC Transaccion Punto Adicional'
  , 'COBRO_OCC',(select MAX(tipopedd) from operacion.tipopedd where upper(abrev)='REMARK_COBRO_OCC'),1);
  
commit;
/