-- Create table
create table OPERACION.INT_PARAMETRO
(
  id_interface NUMBER not null,
  id_parametro VARCHAR2(100) not null,
  id_valor     VARCHAR2(100),
  fecusu       DATE default SYSDATE,
  codusu       VARCHAR2(30) default USER,
  orden        NUMBER,
  tipo         NUMBER default 1
)
tablespace OPERACION_DAT;
-- Add comments to the columns 
comment on column OPERACION.INT_PARAMETRO.id_interface
  is 'Id Interface';
comment on column OPERACION.INT_PARAMETRO.id_parametro
  is 'Id Parametro';
comment on column OPERACION.INT_PARAMETRO.id_valor
  is 'Valor';
comment on column OPERACION.INT_PARAMETRO.fecusu
  is 'Usuario Registro';
comment on column OPERACION.INT_PARAMETRO.codusu
  is 'Fecha Registro';
comment on column OPERACION.INT_PARAMETRO.orden
  is 'Orden';
comment on column OPERACION.INT_PARAMETRO.tipo
  is '2: Variable 1 Constante';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.INT_PARAMETRO
  add constraint PK_INT_INTERFACE_PARAMETRO primary key (ID_INTERFACE, ID_PARAMETRO)
  using index 
  tablespace OPERACION_IDX;
