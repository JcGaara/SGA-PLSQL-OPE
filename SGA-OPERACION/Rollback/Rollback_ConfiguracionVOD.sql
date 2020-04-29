/*------------Eliminar TV ADICIONAL VOD---------*/
declare
v_idcab number;
begin
    select idcab into v_idcab from OPERACION.OPE_cab_XML where PROGRAMA='tv_adicional_vod';
	delete from sgacrm.ft_tiptra_escenario where tiptra=658 AND tipsrv='0062' AND idcab=v_idcab AND escenario=5;
	delete from OPERACION.OPE_det_XML where IDCAB = v_idcab;
	delete from OPERACION.OPE_cab_XML where PROGRAMA='tv_adicional_vod' AND idcab=v_idcab;
    commit;
end;

