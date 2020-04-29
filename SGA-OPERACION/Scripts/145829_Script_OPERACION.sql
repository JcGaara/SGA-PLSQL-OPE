-- Add/modify columns 
alter table OPERACION.TIPTRABAJOXFOR add TIPSRV VARCHAR2(30);
alter table OPERACION.TIPTRABAJOXFOR add FECUSU DATE default SYSDATE;
alter table OPERACION.TIPTRABAJOXFOR add CODUSU VARCHAR2(30) default user;
-- Add comments to the columns 
comment on column OPERACION.TIPTRABAJOXFOR.TIPSRV
  is 'Codigo del tipo de servicio';
comment on column OPERACION.TIPTRABAJOXFOR.FECUSU
  is 'Fecha de registro';
comment on column OPERACION.TIPTRABAJOXFOR.CODUSU
  is 'Codigo de Usuario registro';