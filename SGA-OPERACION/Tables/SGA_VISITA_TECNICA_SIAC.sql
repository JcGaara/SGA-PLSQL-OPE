-- Create table
create table OPERACION.SGA_VISITA_TECNICA_SIAC
(
  co_id           number,
  customer_id     number,
  tmcode          varchar2(50),
  codplansisact   varchar2(50),
  cod_serv_sisact varchar2(50),
  sncode          varchar2(50),
  cod_grupo_serv  varchar2(50),
  codtipequ       varchar2(50),
  tipequ          varchar2(50),
  idequipo        varchar2(50),
  cantidad_equ    varchar2(50),
  tipo_srv        varchar2(50),
  usureg          varchar2(50) default user,
  fecreg          date default sysdate,
  ipaplicacion    varchar2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion    varchar2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT;