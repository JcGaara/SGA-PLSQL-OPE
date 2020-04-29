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
