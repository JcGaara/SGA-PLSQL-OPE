-- Create table
create table OPERACION.VERIFMATERIAL
(
  id_verif         NUMBER not null,
  id_res           NUMBER,
  tran_solmat      NUMBER,
  centro           CHAR(4),
  almacen          CHAR(4),
  unidad           VARCHAR2(10),
  material         CHAR(18),
  cantnecesaria    NUMBER,
  cantcomprometida VARCHAR2(50),
  cantdisponible   VARCHAR2(100),
  flgparcial       CHAR(1),
  flg_reserva      NUMBER,
  mensaje          VARCHAR2(200),
  codsolot         NUMBER,
  clase_val        VARCHAR2(30),
  ipaplicacion     VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion     VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu           VARCHAR2(30) default user,
  fecusu           DATE default sysdate
)
tablespace OPERACION_DAT;
comment on table OPERACION.VERIFMATERIAL
  is 'Tabla para verificar material';
comment on column OPERACION.VERIFMATERIAL.id_verif
  is 'Id Secuencial';
comment on column OPERACION.VERIFMATERIAL.id_res
  is 'Id Reserva';
comment on column OPERACION.VERIFMATERIAL.tran_solmat
  is 'Transaccion Solic Material';
comment on column OPERACION.VERIFMATERIAL.centro
  is 'Centro';
comment on column OPERACION.VERIFMATERIAL.almacen
  is 'Almacen';
comment on column OPERACION.VERIFMATERIAL.unidad
  is 'Unidad';
comment on column OPERACION.VERIFMATERIAL.material
  is 'Material';
comment on column OPERACION.VERIFMATERIAL.cantnecesaria
  is 'Cantidad Necesaria';
comment on column OPERACION.VERIFMATERIAL.cantcomprometida
  is 'Cantidad Comprometida';
comment on column OPERACION.VERIFMATERIAL.cantdisponible
  is 'Cantidad disponible';
comment on column OPERACION.VERIFMATERIAL.flgparcial
  is 'Indicador Parcial';
comment on column OPERACION.VERIFMATERIAL.flg_reserva
  is 'Indicador Reserva';
comment on column OPERACION.VERIFMATERIAL.mensaje
  is 'Mensaje';
comment on column OPERACION.VERIFMATERIAL.codsolot
  is 'SOT';
comment on column OPERACION.VERIFMATERIAL.clase_val
  is 'Clase valoracion';
comment on column OPERACION.VERIFMATERIAL.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.VERIFMATERIAL.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.VERIFMATERIAL.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.VERIFMATERIAL.fecusu
  is 'Fecha de creacion del resgitro';
create index operacion.IDX_VERIFMATERIAL_01 on OPERACION.VERIFMATERIAL (ID_RES)
  tablespace OPERACION_IDX;
alter table OPERACION.VERIFMATERIAL
  add constraint PK_VERIFMATERIAL primary key (ID_VERIF)
  using index 
  tablespace OPERACION_DAT;
