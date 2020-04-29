--Packages
DROP PACKAGE OPERACION.PKG_VISITA_SGA_CE;

--Tablas
drop table OPERACION.SGA_VISITA_TECNICA_CE;

drop table OPERACION.SGAT_POSTV_PROYECTO_ORIGEN;

drop table OPERACION.SGAT_POSTVENTASCE_LOG;

--Configuración
delete from operacion.motot mt
 where mt.descripcion = 'HFC/CE CAMBIO PLAN (SIN VISITA TECNICA)'
   and mt.grupodesc = 'VISITA TECNICA CE';

delete from operacion.motot mt
 where mt.descripcion = 'HFC/CE CAMBIO PLAN (CON VISITA TECNICA)'
   and mt.grupodesc = 'VISITA TECNICA CE';

delete from operacion.tipopedd tp
 where tp.descripcion = 'Tipo de Motivo Visita HFC/CE'
   and tp.abrev = 'TIPO_MOT_HFC_CE_VIS';

delete from operacion.opedd op
 where op.codigoc = 'HFC'
   and op.descripcion = 'HFC/CE CAMBIO PLAN (SIN VISITA TECNICA)'
   and op.abreviacion = 'HFC_SIN_VISTA_CE'
   and op.codigon_aux = 0;

delete from operacion.opedd op
 where op.codigoc = 'HFC'
   and op.descripcion = 'HFC/CE CAMBIO PLAN (CON VISITA TECNICA)'
   and op.abreviacion = 'HFC_CON_VISTA_CE'
   and op.codigon_aux = 1;

Commit;
