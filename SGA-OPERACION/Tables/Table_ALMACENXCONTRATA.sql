-- Create table
create table OPERACION.ALMACENXCONTRATA
(
  tipo         NUMBER,
  codest       VARCHAR2(3),
  codpvc       VARCHAR2(3),
  codcon       NUMBER,
  centro       VARCHAR2(10),
  almacen      VARCHAR2(10),
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu       VARCHAR2(30) default user,
  fecusu       DATE default sysdate
)
tablespace OPERACION_DAT;
-- Add comments to the columns 
comment on column OPERACION.ALMACENXCONTRATA.tipo
  is 'Tipo Provincia 2 Departamento 1';
comment on column OPERACION.ALMACENXCONTRATA.codest
  is 'Codigo Departamento';
comment on column OPERACION.ALMACENXCONTRATA.codpvc
  is 'Codigo de Provincia';
comment on column OPERACION.ALMACENXCONTRATA.codcon
  is 'Codigo de contrata';
comment on column OPERACION.ALMACENXCONTRATA.centro
  is 'Centro';
comment on column OPERACION.ALMACENXCONTRATA.almacen
  is 'Almacen';
comment on column OPERACION.ALMACENXCONTRATA.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.ALMACENXCONTRATA.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.ALMACENXCONTRATA.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.ALMACENXCONTRATA.fecusu
  is 'Fecha de creacion del resgitro';
