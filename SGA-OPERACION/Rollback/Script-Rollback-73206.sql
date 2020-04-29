-- Detalle de parametros
delete from operacion.opedd o
 where o.tipopedd = (select t.tipopedd
                       from operacion.tipopedd t
                      where t.abrev = 'registro_reclamo');

-- Cabecera de parametros
delete from operacion.tipopedd t where t.abrev = 'registro_reclamo';

--Crmdd
delete from sales.crmdd t where t.abreviacion = 'Sara';

-- Tipo Incidencia SARA
delete atccorp.regular_type
where description = 'SARA';

-- Packages y Packages Body
drop package body atccorp.pkg_registro_reclamo;
drop package atccorp.pkg_registro_reclamo;

commit;
