---------------------------------------------------------------------------------------------------------
-- Insertando Cabecera
---------------------------------------------------------------------------------------------------------
insert into operacion.tipopedd (descripcion,abrev) values ('Grupo de Articulo','SOP_GRUPO_ARTICULO');
insert into operacion.tipopedd (descripcion,abrev) values ('Grupo de Necesidad','SOP_GRUPO_NECESIDAD');
---------------------------------------------------------------------------------------------------------
-- Agregando columna de Observacion
---------------------------------------------------------------------------------------------------------
alter table operacion.ope_sp_mat_equ_cab
add observacion varchar2(500);


commit;
/