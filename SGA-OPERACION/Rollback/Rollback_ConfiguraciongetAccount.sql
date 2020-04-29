/*------------Eliminar getAccount---------*/
declare
v_idcab number;
begin
    select idcab into v_idcab from OPERACION.OPE_cab_XML where PROGRAMA='get_account';
	delete from OPERACION.OPE_det_XML where IDCAB = v_idcab;
	delete from OPERACION.OPE_cab_XML where PROGRAMA='get_account' and idcab=v_idcab;
    commit;
end;