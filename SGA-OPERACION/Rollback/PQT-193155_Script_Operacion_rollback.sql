-------------------------------------------------------------------------------------------
-- Articulo
-------------------------------------------------------------------------------------------
delete from operacion.opedd o 
where o.tipopedd=(select tipopedd from tipopedd t where TRIM(t.abrev)='SOP_GRUPO_ARTICULO')
      and o.estado='1';

-------------------------------------------------------------------------------------------
-- Compra
-------------------------------------------------------------------------------------------
-- Eliminando Grupo de Compra insertado por el Req.
delete from operacion.opedd o 
where o.estado='1'
  and o.tipopedd=(select tipopedd from tipopedd t where TRIM(t.abrev)='SOP_GRUPO_COMPRA');

-------------------------------------------------------------------------------------------
-- Necesidad
-------------------------------------------------------------------------------------------
delete from operacion.opedd o 
where o.tipopedd=(select tipopedd from tipopedd t where TRIM(t.abrev)='SOP_GRUPO_NECESIDAD')
      and o.estado='1';

Commit;


delete from operacion.tipopedd tp
where trim(tp.abrev)='SOP_GRUPO_ARTICULO';

delete from operacion.tipopedd tp
where trim(tp.abrev)='SOP_GRUPO_NECESIDAD';


-- Eliminando columna de Observacion
alter table operacion.ope_sp_mat_equ_cab
drop column observacion;

commit;

/