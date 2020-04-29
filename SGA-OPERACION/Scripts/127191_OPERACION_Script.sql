
-- Add/modify columns 
alter table OPERACION.MOT_SOLUCIONXTIPTRA add CODMOT_GRUPO number  default 0 not null;
-- Add comments to the columns 
comment on column OPERACION.MOT_SOLUCIONXTIPTRA.CODMOT_GRUPO
  is 'Codigo grupo solucion';



-- Add/modify columns 
alter table OPERACION.INSSRV add TIPCLI VARCHAR2(10);
alter table OPERACION.INSSRV add CO_ID NUMBER;
alter table OPERACION.INSSRV add CUSTOMER_ID NUMBER;
alter table OPERACION.INSSRV add CUST_CODE VARCHAR2(24);
alter table OPERACION.INSSRV add BILLCYCLE VARCHAR2(2);
alter table OPERACION.INSSRV add IMEI VARCHAR2(40);
alter table OPERACION.INSSRV add SIMCARD VARCHAR2(40);

-- Add comments to the columns 
comment on column OPERACION.INSSRV.TIPCLI
  is 'Tipo de Cliente BSCS';
comment on column OPERACION.INSSRV.CO_ID
  is 'CO ID BSCS';
comment on column OPERACION.INSSRV.CUSTOMER_ID
  is 'Customer ID BSCS';
comment on column OPERACION.INSSRV.CUST_CODE
  is 'CUST CODE BSCS';
comment on column OPERACION.INSSRV.BILLCYCLE
  is 'Ciclo Facturacion BSCS';
comment on column OPERACION.INSSRV.IMEI
  is 'IMEI';
comment on column OPERACION.INSSRV.SIMCARD
  is 'SIMCARD';


-- Add/modify columns 
alter table OPERACION.INSSRV_his add TIPCLI VARCHAR2(10);
alter table OPERACION.INSSRV_his add CO_ID NUMBER;
alter table OPERACION.INSSRV_his add CUSTOMER_ID NUMBER;
alter table OPERACION.INSSRV_his add CUST_CODE VARCHAR2(24);
alter table OPERACION.INSSRV_his add BILLCYCLE VARCHAR2(2);
alter table OPERACION.INSSRV_his add IMEI VARCHAR2(40);
alter table OPERACION.INSSRV_his add SIMCARD VARCHAR2(40);
-- Add comments to the columns 
comment on column OPERACION.INSSRV_his.TIPCLI
  is 'Tipo de Cliente BSCS';
comment on column OPERACION.INSSRV_his.CO_ID
  is 'CO ID BSCS';
comment on column OPERACION.INSSRV_his.CUSTOMER_ID
  is 'Customer ID BSCS';
comment on column OPERACION.INSSRV_his.CUST_CODE
  is 'CUST CODE BSCS';
comment on column OPERACION.INSSRV_his.BILLCYCLE
  is 'Ciclo Facturacion BSCS';
comment on column OPERACION.INSSRV_his.IMEI
  is 'IMEI';
comment on column OPERACION.INSSRV_his.SIMCARD
  is 'SIMCARD';
