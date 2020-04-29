-- Create table
create table OPERACION.MENSAJE_DTH_CAB
(
  idarch  NUMBER not null,
  descrip VARCHAR2(250),
  mensaje VARCHAR2(60),
  tipmsg  NUMBER,
  durmsg  NUMBER(5),
  numrep  NUMBER(3),
  intrep  NUMBER(5),
  fechini DATE,
  horaini DATE,
  estmsg  VARCHAR2(30) default 'Creado',
  obsmsg  VARCHAR2(100),
  canttar NUMBER,
  codmsgd NUMBER,
  usureg  VARCHAR2(30) default USER,
  fecusu  DATE default SYSDATE,
  ipreg   VARCHAR2(15) default SYS_CONTEXT ('USERENV','IP_ADDRESS'),
  fecenv  DATE,
  usuenv  VARCHAR2(20)
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
-- Add comments to the columns 
comment on column OPERACION.MENSAJE_DTH_CAB.idarch
  is 'id principal de la cabecera de mensaje';
comment on column OPERACION.MENSAJE_DTH_CAB.descrip
  is 'Descripcion del mensaje';
comment on column OPERACION.MENSAJE_DTH_CAB.mensaje
  is 'Nombre del Mensaje';
comment on column OPERACION.MENSAJE_DTH_CAB.tipmsg
  is 'Tipo de Mensaje';
comment on column OPERACION.MENSAJE_DTH_CAB.durmsg
  is 'Duracion del Mensaje';
comment on column OPERACION.MENSAJE_DTH_CAB.numrep
  is 'Numero de Repeticiones del mensaje';
comment on column OPERACION.MENSAJE_DTH_CAB.intrep
  is 'Numero de Intervalo de Repeticiones';
comment on column OPERACION.MENSAJE_DTH_CAB.fechini
  is 'Fecha de Inicio de Mensaje';
comment on column OPERACION.MENSAJE_DTH_CAB.horaini
  is 'Hora de Inicio de Mensaje';
comment on column OPERACION.MENSAJE_DTH_CAB.estmsg
  is 'Estado del Mensaje';
comment on column OPERACION.MENSAJE_DTH_CAB.obsmsg
  is 'Observaciones del Mensaje';
comment on column OPERACION.MENSAJE_DTH_CAB.canttar
  is 'Cantidad de Tarjetas';
comment on column OPERACION.MENSAJE_DTH_CAB.codmsgd
  is 'Codigo de Mensage';
comment on column OPERACION.MENSAJE_DTH_CAB.usureg
  is 'Usuario creador del Mensaje';
comment on column OPERACION.MENSAJE_DTH_CAB.fecusu
  is 'Fecha de Creacion del Mensaje';
comment on column OPERACION.MENSAJE_DTH_CAB.ipreg
  is 'IP de la Pc del Usuario';
comment on column OPERACION.MENSAJE_DTH_CAB.fecenv
  is 'Fecha de Registro de Envio';
comment on column OPERACION.MENSAJE_DTH_CAB.usuenv
  is 'Usuario de Registro de Envio';