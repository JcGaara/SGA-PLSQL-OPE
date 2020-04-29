/*------------Eliminar REFRESH STB---------*/
declare
v_idcab number;
begin
    select idcab into v_idcab from OPERACION.OPE_cab_XML where PROGRAMA='refresh_equipo';
	delete from sgacrm.ft_tiptra_escenario where tiptra=658 AND tipsrv='REFR' AND idcab=v_idcab AND escenario=3;
	delete from OPERACION.OPE_det_XML where IDCAB=v_idcab;
	delete from OPERACION.OPE_cab_XML where PROGRAMA='refresh_equipo' AND idcab=v_idcab;
    commit;
end;