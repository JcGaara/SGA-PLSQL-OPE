-- Eliminar detalle de parametros
delete from opedd d  where d.tipopedd in (select t.tipopedd from tipopedd t where t.abrev = 'DECO_ADICIONAL');
-- Eliminar cabecera de parametros
delete from operacion.tipopedd where abrev = 'DECO_ADICIONAL';

COMMIT;
-- Drop columns 
alter table SALES.SISACT_POSTVENTA_DET_SERV_HFC drop column sncode;
alter table SALES.SISACT_POSTVENTA_DET_SERV_HFC drop column spcode;
alter table SALES.SISACT_POSTVENTA_DET_SERV_HFC drop column cargofijo;