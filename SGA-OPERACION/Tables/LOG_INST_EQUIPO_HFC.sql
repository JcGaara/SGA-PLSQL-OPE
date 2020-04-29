-- Create table
create table OPERACION.LOG_INST_EQUIPO_HFC
(
  log_id   NUMBER not null,
  idagenda     NUMBER(8) not null,
  id_interfase varchar2(50),
  modelo       VARCHAR2(20),
  mac          varchar2(50),
  invsn        varchar2(100),
  iderror      number,
  descripcion  varchar2(4000),
  proceso      varchar2(50),
  fecusu  DATE,
  codusu  varchar2(30)
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the columns 
comment on column OPERACION.LOG_INST_EQUIPO_HFC.log_id
  is 'Identificador unico del Mensaje';
comment on column OPERACION.LOG_INST_EQUIPO_HFC.idagenda
  is 'Codigo de la Agenda';
comment on column OPERACION.LOG_INST_EQUIPO_HFC.id_interfase
  is 'Codigo de la Interfase';
comment on column OPERACION.LOG_INST_EQUIPO_HFC.modelo
  is 'Modelo del equipo';
comment on column OPERACION.LOG_INST_EQUIPO_HFC.mac
  is 'MAC del equipo';
comment on column OPERACION.LOG_INST_EQUIPO_HFC.invsn
  is 'Numero de serie';
comment on column OPERACION.LOG_INST_EQUIPO_HFC.iderror
  is 'Codigo de error';
comment on column OPERACION.LOG_INST_EQUIPO_HFC.descripcion
  is 'Descripcion';
comment on column OPERACION.LOG_INST_EQUIPO_HFC.proceso
  is 'Proceso donde se detectó el error';
comment on column OPERACION.LOG_INST_EQUIPO_HFC.fecusu
  is 'Fecha de registro';
comment on column OPERACION.LOG_INST_EQUIPO_HFC.codusu
  is 'Codigo de usuario';