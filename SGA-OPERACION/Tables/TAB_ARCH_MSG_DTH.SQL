-- Create table
create table OPERACION.TAB_ARCH_MSG_DTH
(
  id_archivo     NUMBER not null,
  cod_file       NUMBER(10),
  nombre_file    VARCHAR2(20) not null,
  estado_file    VARCHAR2(50),
  fech_envio     DATE,
  count_tarjetas NUMBER,
  nombre_emm     VARCHAR2(20),
  usu_envio      VARCHAR2(20) default USER,
  usu_mod        VARCHAR2(20),
  fec_mod        DATE,
  cod_est_file   NUMBER,
  observaciones  VARCHAR2(60),
  nun_intentos   NUMBER(8) default 0,
  flg            NUMBER default 0
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