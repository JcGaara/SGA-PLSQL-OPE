create table OPERACION.VTATABCLI_HIS
(
  id     NUMBER(15) not null,
  codcli CHAR(8) not null,
  codsuc CHAR(10) not null,
  coordx NUMBER(15,5),
  coordy NUMBER(15,5),
  feccre DATE default SYSDATE,
  usucre VARCHAR2(30) default USER,
  fecmod DATE,
  usumod VARCHAR2(30),
  ipcre  VARCHAR2(30),
  ipmod  VARCHAR2(30)
)
tablespace OPERACION_DAT;
-- Add comments to the columns 
comment on column OPERACION.VTATABCLI_HIS.id  is 'Identificador';
comment on column OPERACION.VTATABCLI_HIS.codcli  is 'Codigo de cliente';
comment on column OPERACION.VTATABCLI_HIS.codsuc  is 'Codigo de sucursal';
comment on column OPERACION.VTATABCLI_HIS.coordx  is 'Coordenada X';
comment on column OPERACION.VTATABCLI_HIS.coordy  is 'Coordenada Y';
comment on column OPERACION.VTATABCLI_HIS.feccre  is 'Fecha de creacion';
comment on column OPERACION.VTATABCLI_HIS.usucre  is 'Fecha de modificacion';
comment on column OPERACION.VTATABCLI_HIS.fecmod  is 'Fecha de modificacion';
comment on column OPERACION.VTATABCLI_HIS.usumod  is 'Usuario que modifico';
comment on column OPERACION.VTATABCLI_HIS.ipcre  is 'IP que registro';
comment on column OPERACION.VTATABCLI_HIS.ipmod  is 'IP que modifico';