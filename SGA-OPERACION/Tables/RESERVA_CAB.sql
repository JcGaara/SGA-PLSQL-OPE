-- Create table
create table OPERACION.RESERVA_CAB
(
  id_res        NUMBER not null,
  tran_solmat   NUMBER not null,
  fecha         DATE not null,
  usuario       VARCHAR2(30),
  clasemov      CHAR(3) not null,
  pep           VARCHAR2(24) not null,
  numreserva    VARCHAR2(10),
  mensaje       VARCHAR2(200),
  codsolot      NUMBER,
  ipaplicacion  VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion  VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu        VARCHAR2(30) default user,
  fecusu        DATE default sysdate,
  codcon        NUMBER,
  respuesta_sap VARCHAR2(4)
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.RESERVA_CAB
  is 'Listado de reservas';
-- Add comments to the columns 
comment on column OPERACION.RESERVA_CAB.id_res
  is 'Secuencial';
comment on column OPERACION.RESERVA_CAB.tran_solmat
  is 'Transaccion Materiales';
comment on column OPERACION.RESERVA_CAB.fecha
  is 'Fecha Reserva';
comment on column OPERACION.RESERVA_CAB.usuario
  is 'Usuario';
comment on column OPERACION.RESERVA_CAB.clasemov
  is 'Clase Movimiento';
comment on column OPERACION.RESERVA_CAB.pep
  is 'PEP';
comment on column OPERACION.RESERVA_CAB.numreserva
  is 'Numero reserva';
comment on column OPERACION.RESERVA_CAB.mensaje
  is 'Mensaje';
comment on column OPERACION.RESERVA_CAB.codsolot
  is 'SOT';
comment on column OPERACION.RESERVA_CAB.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.RESERVA_CAB.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.RESERVA_CAB.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.RESERVA_CAB.fecusu
  is 'Fecha de creacion del resgitro';
comment on column OPERACION.RESERVA_CAB.respuesta_sap
  is 'Respuesta SAP  E: Error';
-- Create/Recreate indexes 
create index operacion.IDX_RESERVA_CAB_01 on OPERACION.RESERVA_CAB (TRAN_SOLMAT)
  tablespace OPERACION_IDX;
create index operacion.IDX_RESERVA_CAB_02 on OPERACION.RESERVA_CAB (NUMRESERVA)
  tablespace OPERACION_IDX;
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.RESERVA_CAB
  add constraint PK_RESERVA_CAB primary key (ID_RES)
  using index 
  tablespace OPERACION_DAT;
  