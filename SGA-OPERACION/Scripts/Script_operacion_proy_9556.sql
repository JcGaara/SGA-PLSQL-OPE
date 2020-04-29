
declare

ln_tipopedd number;

begin

  /*Carga de datos para configuracion en tipos y estados*/

  insert into operacion.TIPOPEDD (DESCRIPCION, ABREV)
  values ('GENERACION DE CARGOS VOD', 'TIPGENERA_VOD');
      
  commit;


  select TIPOPEDD into ln_tipopedd from operacion.TIPOPEDD t where trim(t.descripcion) = 'GENERACION DE CARGOS VOD';


  insert into operacion.OPEDD (CODIGON, DESCRIPCION, TIPOPEDD, abreviacion)
  values (1, 'TIPO PROCESO 1:AUTOMATICO  -  0: INTERFAZ', ln_tipopedd, 'TIPO_PROCESO');
  
  insert into operacion.OPEDD (CODIGOC, DESCRIPCION, TIPOPEDD, abreviacion)
  values ('01/04/2011', 'Definicion de fecha desde la cual se toman las compras', ln_tipopedd, 'FECREG');

  commit;

end;

/