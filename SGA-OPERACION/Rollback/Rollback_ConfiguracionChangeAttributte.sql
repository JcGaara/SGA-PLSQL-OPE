--Rollback Cambio de Atributo
declare
v_idcab number;
begin
    select idcab into v_idcab from OPERACION.OPE_cab_XML where PROGRAMA='change_attribute_tv_tlf';
	delete from sgacrm.ft_tiptra_escenario where tiptra=613 AND tipsrv='TODO' AND idcab=v_idcab AND escenario=4;
	delete from OPERACION.OPE_det_XML where IDCAB=v_idcab;
	delete from OPERACION.OPE_cab_XML where PROGRAMA='change_attribute_tv_tlf' AND IDCAB=v_idcab;
    commit;
end;
