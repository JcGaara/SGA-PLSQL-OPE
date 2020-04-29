-- Create table
create table OPERACION.REG_ARCHIVOS_CLOUD
(
  numtrans                 NUMBER(15),
  id_cliente               NUMBER,
  crm                      VARCHAR2(50),
  id_categoria             NUMBER,
  nombre_categoria         VARCHAR2(500),
  id_plan                  NUMBER,
  nombre_plan              VARCHAR2(500),
  sku                      VARCHAR2(50),
  cantidad                 NUMBER,
  valor_unitario_sin_imp   NUMBER(18,4),
  valor_total_sin_imp      NUMBER(18,4),
  valor_impuesto_total     NUMBER(18,4),
  valor_total_con_imp      NUMBER(18,4),
  parallels_customer_id    NUMBER,
  parallels_suscription_id NUMBER,
  codigo_vendedor          NUMBER,
  dlstartdate              VARCHAR2(50),
  dlenddate                VARCHAR2(50),
  pay_type                 CHAR(2),
  detail_type              NUMBER,
  billing_type             CHAR(2),
  billing_transaction      CHAR(2),
  credit_id                NUMBER,
  fecusu                   DATE default SYSDATE not null,
  codusu                   VARCHAR2(30) default user not null
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
/