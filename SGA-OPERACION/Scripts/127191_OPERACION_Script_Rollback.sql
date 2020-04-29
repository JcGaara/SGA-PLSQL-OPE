-- Drop columns 
alter table OPERACION.MOT_SOLUCIONXTIPTRA drop column CODMOT_GRUPO;
DROP table OPERACION.MOT_SOLUCION_GRUPO;
DROP table OPERACION.MOT_SOLUCIONXTIPTRA_ACT;
DROP table OPERACION.MOT_SOLUCIONXTIPTRA_MAT;
DROP table OPERACION.PAQUETE_VENTAXFOR;


-- Drop columns 
alter table OPERACION.INSSRV drop column TIPCLI;
alter table OPERACION.INSSRV drop column CO_ID;
alter table OPERACION.INSSRV drop column CUSTOMER_ID;
alter table OPERACION.INSSRV drop column CUST_CODE;
alter table OPERACION.INSSRV drop column BILLCYCLE;
alter table OPERACION.INSSRV drop column IMEI;
alter table OPERACION.INSSRV drop column SIMCARD;

-- Drop columns 
alter table OPERACION.INSSRV_HIS drop column TIPCLI;
alter table OPERACION.INSSRV_HIS drop column CO_ID;
alter table OPERACION.INSSRV_HIS drop column CUSTOMER_ID;
alter table OPERACION.INSSRV_HIS drop column CUST_CODE;
alter table OPERACION.INSSRV_HIS drop column BILLCYCLE;
alter table OPERACION.INSSRV_HIS drop column IMEI;
alter table OPERACION.INSSRV_HIS drop column SIMCARD;

-- Drop indexes 
drop index OPERACION.IDK_OPE_LST_FIL_TMP_VALOR;
drop index OPERACION.IDK_CODCLIIDAGENDA;
