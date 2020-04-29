-- Add/modify columns 
alter table OPERACION.DISTRITOXCONTRATA add tipsrv varchar2(4);
alter table OPERACION.DISTRITOXCONTRATA add codsol varchar2(10);
-- Add comments to the columns 
comment on column OPERACION.DISTRITOXCONTRATA.tipsrv
  is 'Tipo de Servicio';
comment on column OPERACION.DISTRITOXCONTRATA.codsol
  is 'Punto de Venta';