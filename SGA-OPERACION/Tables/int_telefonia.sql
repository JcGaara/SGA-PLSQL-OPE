-- Create table
create table OPERACION.INT_TELEFONIA
(
  id                 NUMBER(10) not null,
  idtareawf          NUMBER(8),
  idwf               NUMBER(8),
  tarea              NUMBER(6),
  tareadef           NUMBER(6),
  codsolot           NUMBER(8),
  operacion          VARCHAR2(30),
  plataforma_origen  VARCHAR2(30),
  plataforma_destino VARCHAR2(30),
  error_id           NUMBER(1),
  mensaje            VARCHAR2(4000),
  tipestsol          NUMBER(2),
  usureg             VARCHAR2(30) default USER not null,
  fecreg             DATE default SYSDATE not null
);
-- Add comments to the columns 
comment on column OPERACION.INT_TELEFONIA.id
  is 'PK identificador de la transaccion';
comment on column OPERACION.INT_TELEFONIA.idtareawf
  is 'ID de la tarea';
comment on column OPERACION.INT_TELEFONIA.idwf
  is 'ID de la instancia de workflow';
comment on column OPERACION.INT_TELEFONIA.tarea
  is 'ID de la tarea para una definición de wf';
comment on column OPERACION.INT_TELEFONIA.tareadef
  is 'ID de la Tarea';
comment on column OPERACION.INT_TELEFONIA.codsolot
  is 'Codigo de la solicitud de orden de trabajo';
comment on column OPERACION.INT_TELEFONIA.operacion
  is 'Tipo de operacion en SGA : alta-baja-cp-te-suspension-reconexion-corte';
comment on column OPERACION.INT_TELEFONIA.plataforma_origen
  is 'Plataforma de origen';
comment on column OPERACION.INT_TELEFONIA.plataforma_destino
  is 'Plataforma de destino';
comment on column OPERACION.INT_TELEFONIA.error_id
  is 'Error general 0:ninguno, -1: alguno';
comment on column OPERACION.INT_TELEFONIA.mensaje
  is 'Mensaje de salida del proceso';
comment on column OPERACION.INT_TELEFONIA.tipestsol
  is 'Estado de la SOT';
comment on column OPERACION.INT_TELEFONIA.usureg
  is 'Usuario creacion';
comment on column OPERACION.INT_TELEFONIA.fecreg
  is 'Fecha creacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.INT_TELEFONIA
  add constraint PK_INT_TELEFONIA primary key (ID);
