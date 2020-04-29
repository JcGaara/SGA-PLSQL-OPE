
-- Add/modify columns 
alter table OPERACION.DISTRITOXCONTRATA add CODCON_TPI number;
-- Add comments to the columns 
comment on column OPERACION.DISTRITOXCONTRATA.CODCON_TPI
  is 'Codigo de Contrata que Vende TPI';

grant delete on OPERACION.DISTRITOXCONTRATA to R_PROD;


UPDATE PAQUETE_vENTA SET DESC_OPERATIVA = OBSERVACION;

COMMIT;