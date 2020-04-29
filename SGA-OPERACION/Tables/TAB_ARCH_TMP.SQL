-- Create table
create table OPERACION.TAB_ARCH_TMP
(
  id_archivo     NUMBER not null,
  cod_file       NUMBER(10),
  nombre_file    VARCHAR2(20),
  estado_file    VARCHAR2(50),
  count_tarjetas NUMBER,
  fecusu         DATE default SYSDATE
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