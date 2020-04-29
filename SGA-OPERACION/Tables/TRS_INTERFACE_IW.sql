-- Create table
create table OPERACION.TRS_INTERFACE_IW
(
  idtrs             NUMBER not null,
  tip_interfase     VARCHAR2(3),
  id_interfase      VARCHAR2(10),
  valores           VARCHAR2(400),
  modelo            VARCHAR2(30),
  mac_address       VARCHAR2(40),
  unit_address      VARCHAR2(40),
  customer_id       NUMBER,
  codigo_ext        VARCHAR2(30),
  id_producto       VARCHAR2(20),
  id_producto_padre VARCHAR2(20),
  id_servicio_padre VARCHAR2(10),
  cod_id            NUMBER,
  codcli            VARCHAR2(10),
  codsolot          NUMBER,
  codinssrv         NUMBER,
  pidsga            NUMBER,
  id_servicio       VARCHAR2(10),
  estado            NUMBER default 0,
  codactivacion     VARCHAR2(32),
  fecusu            DATE default SYSDATE,
  codusu            VARCHAR2(30) default USER
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.TRS_INTERFACE_IW
  is 'Transaciones de SGA a BSCS';
-- Add comments to the columns 
comment on column OPERACION.TRS_INTERFACE_IW.idtrs
  is 'ID';
comment on column OPERACION.TRS_INTERFACE_IW.tip_interfase
  is 'Tipo de Interface';
comment on column OPERACION.TRS_INTERFACE_IW.id_interfase
  is 'ID interface';
comment on column OPERACION.TRS_INTERFACE_IW.valores
  is 'Valores';
comment on column OPERACION.TRS_INTERFACE_IW.modelo
  is 'Modelo deco mta';
comment on column OPERACION.TRS_INTERFACE_IW.mac_address
  is 'MAC';
comment on column OPERACION.TRS_INTERFACE_IW.unit_address
  is 'Unit Address';
comment on column OPERACION.TRS_INTERFACE_IW.customer_id
  is 'Customer id';
comment on column OPERACION.TRS_INTERFACE_IW.codigo_ext
  is 'Codigo Externo';
comment on column OPERACION.TRS_INTERFACE_IW.id_producto
  is 'Id Producto';
comment on column OPERACION.TRS_INTERFACE_IW.id_producto_padre
  is 'Id Producto Padre';
comment on column OPERACION.TRS_INTERFACE_IW.id_servicio_padre
  is 'Id Servicio Padre';
comment on column OPERACION.TRS_INTERFACE_IW.cod_id
  is 'Cod ID';
comment on column OPERACION.TRS_INTERFACE_IW.codcli
  is 'Codigo de Cliente';
comment on column OPERACION.TRS_INTERFACE_IW.codsolot
  is 'SOT';
comment on column OPERACION.TRS_INTERFACE_IW.codinssrv
  is 'SID';
comment on column OPERACION.TRS_INTERFACE_IW.pidsga
  is 'PID';
comment on column OPERACION.TRS_INTERFACE_IW.id_servicio
  is 'Id Servicio';
comment on column OPERACION.TRS_INTERFACE_IW.estado
  is 'Estado';
comment on column OPERACION.TRS_INTERFACE_IW.codactivacion
  is 'Codigo Activa';
comment on column OPERACION.TRS_INTERFACE_IW.fecusu
  is 'Fecha Registro';
comment on column OPERACION.TRS_INTERFACE_IW.codusu
  is 'Usuario Registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TRS_INTERFACE_IW
  add constraint PK_INT_MEN_INT primary key (IDTRS)
  using index 
  tablespace OPERACION_DAT;
