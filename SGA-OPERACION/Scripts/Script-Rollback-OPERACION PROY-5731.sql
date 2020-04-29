DROP SEQUENCE operacion.sq_ope_srv_reginst_sisact;
DROP TRIGGER operacion.t_ope_srv_reginst_sisact_bi;
DROP TABLE operacion.ope_srv_reginst_sisact;


-- Drop columns 
alter table OPERACION.OPE_SRV_RECARGA_CAB drop column ID_SISACT;
alter table OPERACION.OPE_SRV_RECARGA_CAB drop column FLAG_VERIF_CONAX;