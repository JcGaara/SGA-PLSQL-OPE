/*Carga de datos para configuracion de WF*/

declare
ln_tipopedd number;

begin
select TIPOPEDD into ln_tipopedd from operacion.TIPOPEDD t where trim(t.descripcion) = 'OP-Asig Flujo Automaticos';

insert into operacion.OPEDD (CODIGON, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
values (838, 'INSTALACION WIMAX', ln_tipopedd, null);
commit;
end;
/