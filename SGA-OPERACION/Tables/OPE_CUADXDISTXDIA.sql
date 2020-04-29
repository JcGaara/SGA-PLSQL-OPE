-- Create table
create table OPERACION.OPE_CUADXDISTXDIA
(
  CODUBI       VARCHAR2(10) not null,
  TIPTRA       NUMBER not null,
  CODCON       NUMBER not null,
  CODCUADRILLA VARCHAR2(30) not null,
  D1           NUMBER,
  D2           NUMBER,
  D3           NUMBER,
  D4           NUMBER,
  D5           NUMBER,
  D6           NUMBER,
  D7           NUMBER,
  D8           NUMBER,
  D9           NUMBER,
  D10          NUMBER,
  D11          NUMBER,
  D12          NUMBER,
  D13          NUMBER,
  D14          NUMBER,
  D15          NUMBER,
  D16          NUMBER,
  D17          NUMBER,
  D18          NUMBER,
  D19          NUMBER,
  D20          NUMBER,
  D21          NUMBER,
  D22          NUMBER,
  D23          NUMBER,
  D24          NUMBER,
  D25          NUMBER,
  D26          NUMBER,
  D27          NUMBER,
  D28          NUMBER,
  D29          NUMBER,
  D30          NUMBER,
  D31          NUMBER,
  CODUSU       VARCHAR2(30) default USER,
  FECUSU       DATE default SYSDATE
) ;
-- Add comments to the columns 
comment on column OPERACION.OPE_CUADXDISTXDIA.CODUBI
  is 'Ubigeo';
comment on column OPERACION.OPE_CUADXDISTXDIA.TIPTRA
  is 'Tipo de Trabajo';
comment on column OPERACION.OPE_CUADXDISTXDIA.CODCON
  is 'Codigo de contrata';
comment on column OPERACION.OPE_CUADXDISTXDIA.CODCUADRILLA
  is 'Cuadrilla';
comment on column OPERACION.OPE_CUADXDISTXDIA.D1
  is 'Dia 1';
comment on column OPERACION.OPE_CUADXDISTXDIA.D2
  is 'Dia 2';
comment on column OPERACION.OPE_CUADXDISTXDIA.D3
  is 'Dia 3';
comment on column OPERACION.OPE_CUADXDISTXDIA.D4
  is 'Dia 4';
comment on column OPERACION.OPE_CUADXDISTXDIA.D5
  is 'Dia 5';
comment on column OPERACION.OPE_CUADXDISTXDIA.D6
  is 'Dia 6';
comment on column OPERACION.OPE_CUADXDISTXDIA.D7
  is 'Dia 7';
comment on column OPERACION.OPE_CUADXDISTXDIA.D8
  is 'Dia 8';
comment on column OPERACION.OPE_CUADXDISTXDIA.D9
  is 'Dia 9';
comment on column OPERACION.OPE_CUADXDISTXDIA.D10
  is 'Dia 10';
comment on column OPERACION.OPE_CUADXDISTXDIA.D11
  is 'Dia 11';
comment on column OPERACION.OPE_CUADXDISTXDIA.D12
  is 'Dia 12';
comment on column OPERACION.OPE_CUADXDISTXDIA.D13
  is 'Dia 13';
comment on column OPERACION.OPE_CUADXDISTXDIA.D14
  is 'Dia 14';
comment on column OPERACION.OPE_CUADXDISTXDIA.D15
  is 'Dia 15';
comment on column OPERACION.OPE_CUADXDISTXDIA.D16
  is 'Dia 16';
comment on column OPERACION.OPE_CUADXDISTXDIA.D17
  is 'Dia 17';
comment on column OPERACION.OPE_CUADXDISTXDIA.D18
  is 'Dia 18';
comment on column OPERACION.OPE_CUADXDISTXDIA.D19
  is 'Dia 19';
comment on column OPERACION.OPE_CUADXDISTXDIA.D20
  is 'Dia 20';
comment on column OPERACION.OPE_CUADXDISTXDIA.D21
  is 'Dia 21';
comment on column OPERACION.OPE_CUADXDISTXDIA.D22
  is 'Dia 22';
comment on column OPERACION.OPE_CUADXDISTXDIA.D23
  is 'Dia 23';
comment on column OPERACION.OPE_CUADXDISTXDIA.D24
  is 'Dia 24';
comment on column OPERACION.OPE_CUADXDISTXDIA.D25
  is 'Dia 25';
comment on column OPERACION.OPE_CUADXDISTXDIA.D26
  is 'Dia 26';
comment on column OPERACION.OPE_CUADXDISTXDIA.D27
  is 'Dia 27';
comment on column OPERACION.OPE_CUADXDISTXDIA.D28
  is 'Dia 28';
comment on column OPERACION.OPE_CUADXDISTXDIA.D29
  is 'Dia 29';
comment on column OPERACION.OPE_CUADXDISTXDIA.D30
  is 'Dia 30';
comment on column OPERACION.OPE_CUADXDISTXDIA.D31
  is 'Dia 31';
comment on column OPERACION.OPE_CUADXDISTXDIA.CODUSU
  is 'Usuario de registr';
comment on column OPERACION.OPE_CUADXDISTXDIA.FECUSU
  is 'Fecha de registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_CUADXDISTXDIA
  add constraint PK_OPE_CUADXDISTXDIA1 primary key (CODUBI, TIPTRA, CODCON, CODCUADRILLA) ;
-- Create/Recreate indexes 
create index OPERACION.IDK_OPE_CUADXDISTXDIA1 on OPERACION.OPE_CUADXDISTXDIA (CODUBI, TIPTRA)
  tablespace OPERACION_DAT ;