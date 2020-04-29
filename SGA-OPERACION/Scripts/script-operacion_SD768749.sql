/*Creamos parametros en la OPEDD*/
insert into operacion.opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   (select tiptra
      from tiptrabajo
     where descripcion = 'HFC - BAJA SERVICIO TELEFONIA - POR OUT'),
   'Tipo Trabajo Baja Port Out',
   'TTBPO',
   (select tipopedd
      from tipopedd
     where abrev in ('PARAM_PORTA')),
   0);   

insert into operacion.opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   (select wfdef
      from wfdef
     where descripcion = 'BAJA DE SERVICIO - PORTOUT'),
   'Workflow Baja Port Out',
   'WBPO',
   (select tipopedd
      from tipopedd
     where abrev in ('PARAM_PORTA')),
   0); 
   
insert into operacion.opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('0073',
   null,
   'Tipo de Servicio CE',
   'TSCE',
   (select tipopedd
      from tipopedd
     where abrev in ('PARAM_PORTA')),
   1);   

commit;
/   