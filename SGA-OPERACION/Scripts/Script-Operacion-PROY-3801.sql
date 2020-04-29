declare

begin

insert into OPERACION.TIPOPEDD (DESCRIPCION, ABREV)
values ('Activación por IVR DTH- Tareas', 'IVR_DTH');
     
 commit;
end;
/

declare
ln_tipopedd number;

begin
select TIPOPEDD into ln_tipopedd from operacion.TIPOPEDD where abrev='IVR_DTH';

insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)values (801,'Inalambrico - Registro de datos', 'REG_DTH', ln_tipopedd);
insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)values (802,'Inalambrico - Activación/Desactivación Conax','ACT_DTH', ln_tipopedd);
insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)values (815,'Inalambrico - Programación','PROG_DTH', ln_tipopedd);
insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)values (1070,'Validación del Instalador del Servicio Claro TV Sat', 'INSTALADOR_DTH', ln_tipopedd);
commit;
end;
/
