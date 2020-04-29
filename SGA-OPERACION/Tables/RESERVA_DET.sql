-- Create table
create table OPERACION.RESERVA_DET
(
  id_res         NUMBER not null,
  id_res_det     NUMBER not null,
  material       VARCHAR2(18),
  centro         CHAR(4),
  almacen        VARCHAR2(4),
  cantidad       NUMBER,
  unidad         CHAR(3),
  fechanecesidad DATE,
  clase_val      VARCHAR2(30),
  ipaplicacion   VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion   VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu         VARCHAR2(30) default user,
  fecusu         DATE default sysdate
)
tablespace OPERACION_DAT;
comment on table OPERACION.RESERVA_DET
  is 'Detalle reserva';
comment on column OPERACION.RESERVA_DET.id_res
  is 'Id Res';
comment on column OPERACION.RESERVA_DET.id_res_det
  is 'Detalle secuencial';
comment on column OPERACION.RESERVA_DET.material
  is 'Codigo material';
comment on column OPERACION.RESERVA_DET.centro
  is 'Centro';
comment on column OPERACION.RESERVA_DET.almacen
  is 'Almacen';
comment on column OPERACION.RESERVA_DET.cantidad
  is 'Cantidad';
comment on column OPERACION.RESERVA_DET.unidad
  is 'Unidad';
comment on column OPERACION.RESERVA_DET.fechanecesidad
  is 'Fecha necesidad';
comment on column OPERACION.RESERVA_DET.clase_val
  is 'Clase Valoracion';
comment on column OPERACION.RESERVA_DET.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.RESERVA_DET.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.RESERVA_DET.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.RESERVA_DET.fecusu
  is 'Fecha de creacion del resgitro';
alter table OPERACION.RESERVA_DET
  add constraint PK_RESERVA_DET primary key (ID_RES, ID_RES_DET)
  using index 
  tablespace OPERACION_DAT;
alter table OPERACION.RESERVA_DET
  add constraint FK_RESERVA_DET_CAB foreign key (ID_RES)
  references OPERACION.RESERVA_CAB (ID_RES) on delete cascade;