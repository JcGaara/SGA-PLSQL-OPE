-- Borrar Configuración Plantilla de SOT

delete from OPE_PLANTILLASOT where IDPLANSOT>45 and IDPLANSOT<=95;

-- Borrar Configuración del opedd

delete from opedd where TIPOPEDD in (select tipopedd from tipopedd where abrev = 'TIP_CONF_CORTE') and CODIGON=3;


-- Borrar Vistas Materializadas

drop materialized view COLLECTIONS.VM_REC_FACTURAVENCIDA_CORP;
drop materialized view COLLECTIONS.VM_REC_INSTANCIA_SERVICIO_CORP;

COMMIT;