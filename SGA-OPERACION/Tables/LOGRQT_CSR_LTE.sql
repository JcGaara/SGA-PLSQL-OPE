-- Create table
create table OPERACION.LOGRQT_CSR_LTE
(
  id            NUMBER not null,
  request_padre NUMBER,
  request       NUMBER,
  customer_id   NUMBER,
  co_id         NUMBER,
  action_id     NUMBER,
  action_des    VARCHAR2(50),
  origen_prov   VARCHAR2(50),
  tipo_prod     VARCHAR2(20),
  codusucre     VARCHAR2(50) default user,
  fechcre       DATE default sysdate,
  sot           NUMBER,
  mensaje       VARCHAR2(3000)
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
-- Add comments to the table 
comment on table OPERACION.LOGRQT_CSR_LTE
  is 'Tabla encargada de guardar los registros de las requets procesados por lado del SGA de la BSCS para Corte/Suspension/Reconexion/Cancelacion/Alta y Baja de Servicios Adicionales';
-- Add comments to the columns 
comment on column OPERACION.LOGRQT_CSR_LTE.id
  is 'Identificador del Proceso';
comment on column OPERACION.LOGRQT_CSR_LTE.request_padre
  is 'Request Padre generado en la BSCS';
comment on column OPERACION.LOGRQT_CSR_LTE.request
  is 'Request del Servicio generado en la BSCS';
comment on column OPERACION.LOGRQT_CSR_LTE.customer_id
  is 'Codigo de Customer_Id de la BSCS';
comment on column OPERACION.LOGRQT_CSR_LTE.co_id
  is 'Codigo de Co_Id de la BSCS';
comment on column OPERACION.LOGRQT_CSR_LTE.action_id
  is 'Identificador del Action de la BSCS';
comment on column OPERACION.LOGRQT_CSR_LTE.action_des
  is 'Descripcion del Action de la BSCS';
comment on column OPERACION.LOGRQT_CSR_LTE.origen_prov
  is 'Origen de Provision, Generados por OAC, Generados por SIAC';
comment on column OPERACION.LOGRQT_CSR_LTE.codusucre
  is 'Codigo de Usuario Creador de registro';
comment on column OPERACION.LOGRQT_CSR_LTE.fechcre
  is 'Fecha de Creacion de Registro';
comment on column OPERACION.LOGRQT_CSR_LTE.sot
  is 'SOT generada';
comment on column OPERACION.LOGRQT_CSR_LTE.mensaje
  is 'Mensaje del Proceso';