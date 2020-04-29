-- Create table
create table OPERACION.SGAT_VISITA_PROTOTYPE
(
  co_id           NUMBER,
  customer_id     NUMBER,
  cod_cli         NUMBER,
  pid             number(10),
  CODSRV          CHAR(4),
  CODINSSRV       NUMBER(10),
  codequcom       CHAR(4),
  tipequ          VARCHAR2(50),
  cantidad_equ    VARCHAR2(50),
  tipo_srv        VARCHAR2(50),
  codsolot_OLD    NUMBER,
  codsolot_new    number,
  tipo_transaccion  char(3),
  tipo_Accion     varchar2(50),
  usureg          VARCHAR2(50)  default user,
  fecreg          DATE default  sysdate,
  ipaplicacion    VARCHAR2(30)  default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion    VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT;
-- Add comments to the columns 
comment on column OPERACION.SGAT_VISITA_PROTOTYPE.co_id
  is 'CONTRATO';
comment on column OPERACION.SGAT_VISITA_PROTOTYPE.customer_id
  is 'CLIENTE';
comment on column OPERACION.SGAT_VISITA_PROTOTYPE.pid
  is 'Numero de la instancia de producto';
comment on column OPERACION.SGAT_VISITA_PROTOTYPE.CODSRV
  is 'Codigo de servicio';
comment on column OPERACION.SGAT_VISITA_PROTOTYPE.CODINSSRV
  is 'Codigo de instancia de servicio';
comment on column OPERACION.SGAT_VISITA_PROTOTYPE.codequcom
  is 'Codigo del equipo comercial';
comment on column OPERACION.SGAT_VISITA_PROTOTYPE.tipo_transaccion
  is 'HFC / LTE';
comment on column OPERACION.SGAT_VISITA_PROTOTYPE.tipo_Accion
  is 'INSTALAR / RETIRAR / CAMBIAR / NO APLICA';
/