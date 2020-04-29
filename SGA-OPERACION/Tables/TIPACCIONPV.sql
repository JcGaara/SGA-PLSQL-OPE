-- Create table
create table OPERACION.TIPACCIONPV
(
  idaccpv     NUMBER not null,
  desaccpv    VARCHAR2(80),
  origen      NUMBER,
  estado      NUMBER,
  usuario     VARCHAR2(20),
  fecreg      DATE default SYSDATE,
  fecmodif    DATE,
  idtrancorte NUMBER,
  tipo        NUMBER(1),
  flg_cnr     NUMBER(1)
) ;
-- Add comments to the columns 
comment on column OPERACION.TIPACCIONPV.idaccpv
  is 'ID de la acción de postventa.';
comment on column OPERACION.TIPACCIONPV.desaccpv
  is 'Es la descripción de la acción de postventa.';
comment on column OPERACION.TIPACCIONPV.origen
  is 'Identifica el origen de acción de postventa 1: OPE, 2: ATC';
comment on column OPERACION.TIPACCIONPV.estado
  is 'Estado de la acción: 0; Desactivo, 1: Activo';
comment on column OPERACION.TIPACCIONPV.usuario
  is 'Usuario que registra la accion de postventa.';
comment on column OPERACION.TIPACCIONPV.fecreg
  is 'Fecha de registro.';
comment on column OPERACION.TIPACCIONPV.fecmodif
  is 'Fecha de modificacion.';
comment on column OPERACION.TIPACCIONPV.idtrancorte
  is 'Id tran Corte';
comment on column OPERACION.TIPACCIONPV.tipo
  is 'Tipos de Servicios 1: TOTAL, 2: SOLO BAF, 3: SOLO BAM';
comment on column OPERACION.TIPACCIONPV.flg_cnr
  is 'Flag CNR 0: Sin CNR, 1: Con CNR';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TIPACCIONPV
  add constraint TIPACCIONPV_PK primary key (IDACCPV) ;
-- Grant/Revoke object privileges 
grant select, insert, update, delete on OPERACION.TIPACCIONPV to R_SOAP_DB;
