-- Create table
create table OPERACION.TELEFONIA_CE
(
  id_telefonia_ce NUMBER(10) not null,
  idtareawf       NUMBER(8),
  idwf            NUMBER(8),
  tarea           NUMBER(6),
  tareadef        NUMBER(6),
  codsolot        NUMBER(8),
  operacion       VARCHAR2(30),
  id_error        NUMBER(1),
  mensaje         VARCHAR2(2000),
  usureg          VARCHAR2(30) default USER not null,
  fecreg          DATE default SYSDATE not null,
  usumod          VARCHAR2(30) default user not null,
  fecmod          DATE default SYSDATE not null
);
-- Add comments to the columns 
comment on column OPERACION.TELEFONIA_CE.id_telefonia_ce
  is 'PK identificador de la transaccion';
comment on column OPERACION.TELEFONIA_CE.idtareawf
  is 'ID de la tarea';
comment on column OPERACION.TELEFONIA_CE.idwf
  is 'ID de la instancia de workflow';
comment on column OPERACION.TELEFONIA_CE.tarea
  is 'ID de la tarea para una definición de wf';
comment on column OPERACION.TELEFONIA_CE.tareadef
  is 'ID de la Tarea';
comment on column OPERACION.TELEFONIA_CE.codsolot
  is 'Codigo de la solicitud de orden de trabajo';
comment on column OPERACION.TELEFONIA_CE.operacion
  is 'Tipo de operacion en SGA : alta-baja-cp-te-suspension-reconexion-corte';
comment on column OPERACION.TELEFONIA_CE.id_error
  is 'Error general 0:ninguno, -1: alguno';
comment on column OPERACION.TELEFONIA_CE.mensaje
  is 'Mensaje de salida del proceso';
comment on column OPERACION.TELEFONIA_CE.usureg
  is 'Usuario creacion';
comment on column OPERACION.TELEFONIA_CE.fecreg
  is 'Fecha creacion';
comment on column OPERACION.TELEFONIA_CE.usumod
  is 'Usuario modificacion';
comment on column OPERACION.TELEFONIA_CE.fecmod
  is 'Fecha modificacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TELEFONIA_CE
  add constraint PK_TELEFONIA_CE primary key (ID_TELEFONIA_CE);
