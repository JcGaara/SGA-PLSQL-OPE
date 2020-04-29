/*Creamos los Tipo de Trabajo*/
insert into tiptrabajo
  (tiptra, tiptrs, descripcion)
values
  ((select max(tiptra) + 1 from tiptrabajo),
   1,
   'HFC/SIAC SERVICIOS ADICIONALES');

insert into tiptrabajo
  (tiptra, tiptrs, descripcion)
values
  ((select max(tiptra) + 1 from tiptrabajo),
   1,
   'HFC/SIAC BAJA SERVICIOS ADICIONALES');

/*Creamos parametro en la TIPOPEDD*/
insert into tipopedd
  (DESCRIPCION, ABREV)
values
  ('HFC/SIAC SERVICIO ADICIONAL', 'HFC_SIAC_SERVICIO_ADICIONAL');

/*Creamos parametros en la OPEDD*/
insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   (select tiptra
      from tiptrabajo
     where descripcion = 'HFC/SIAC SERVICIOS ADICIONALES'),
   'Tipo Trabajo Servicio Adicional',
   'TIPTRA_SADI',
   (select tipopedd
      from tipopedd
     where abrev = 'HFC_SIAC_SERVICIO_ADICIONAL'),
   0);

insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   (select tiptra
      from tiptrabajo
     where descripcion = 'HFC/SIAC BAJA SERVICIOS ADICIONALES'),
   'Tipo Trabajo Baja Servicio Adicional',
   'TIPTRA_BSADI',
   (select tipopedd
      from tipopedd
     where abrev = 'HFC_SIAC_SERVICIO_ADICIONAL'),
   0);

insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   667,
   'Codigo del Motivo',
   'codigomotivo',
   (select tipopedd
      from tipopedd
     where abrev = 'HFC_SIAC_SERVICIO_ADICIONAL'),
   0);

insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('09:00',
   null,
   'Franja Horaria',
   'franjaHoraria',
   (select tipopedd
      from tipopedd
     where abrev = 'HFC_SIAC_SERVICIO_ADICIONAL'),
   0);

insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   (select wfdef
      from wfdef
     where descripcion = 'HFC/SIAC - SERVICIO ADICIONAL'),
   'Work Flow Servicio Adicional',
   'WFSERADI',
   (select tipopedd
      from tipopedd
     where abrev = 'HFC_SIAC_SERVICIO_ADICIONAL'),
   0);

insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   3,
   'ID Proceso Activación',
   'PASEVADI',
   (select tipopedd
      from tipopedd
     where abrev = 'HFC_SIAC_SERVICIO_ADICIONAL'),
   0);

insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   4,
   'ID Proceso Desactivación',
   'PDSEVADI',
   (select tipopedd
      from tipopedd
     where abrev = 'HFC_SIAC_SERVICIO_ADICIONAL'),
   0);

insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   2240,
   'CODIGO OCC - HFC/SIAC SERVICIO ADICIONAL',
   'COD_OCC',
   (select tipopedd
      from tipopedd
     where abrev = 'HFC_SIAC_SERVICIO_ADICIONAL'),
   null);

insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   1,
   'NUMERO CUOTAS - HFC/SIAC SERVICIO ADICIONAL',
   'NUM_CUOTAS',
   (select tipopedd
      from tipopedd
     where abrev = 'HFC_SIAC_SERVICIO_ADICIONAL'),
   null);

insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (1.18,
   null,
   'IGV - HFC/SIAC SERVICIO ADICIONAL',
   'IGV',
   (select tipopedd
      from tipopedd
     where abrev = 'HFC_SIAC_SERVICIO_ADICIONAL'),
   null);

insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('Servicio Adicional para cable',
   null,
   'DESCRIPCION PID - HFC/SIAC SERVICIO ADICIONAL',
   'DESC_PID',
   (select tipopedd
      from tipopedd
     where abrev = 'HFC_SIAC_SERVICIO_ADICIONAL'),
   null);

insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   (select tiptra
      from tiptrabajo
     where descripcion = 'HFC/SIAC SERVICIOS ADICIONALES'),
   'HFC/SIAC - SERVICIO ADICIONAL',
   null,
   (select tipopedd from tipopedd where abrev = 'ASIGNARWFBSCS'),
   4);

insert into opedd
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   (select tiptra
      from tiptrabajo
     where descripcion = 'HFC/SIAC BAJA SERVICIOS ADICIONALES'),
   'HFC/SIAC - BAJA SERVICIO ADICIONAL',
   null,
   (select tipopedd from tipopedd where abrev = 'ASIGNARWFBSCS'),
   5);

/*Creamos constantes*/
insert into constante
  (CONSTANTE, DESCRIPCION, TIPO, VALOR)
values
  ('DATESADSIACINI',
   'Fecha de inicio de Activación Servicio Adicional SIAC',
   'C',
   '26/02/2016');

insert into constante
  (CONSTANTE, DESCRIPCION, TIPO, VALOR)
values
  ('DATEBSADSIACINI',
   'Fecha de inicio de Desactivación Servicio Adicional SIAC',
   'C',
   '26/02/2016');

COMMIT;
/