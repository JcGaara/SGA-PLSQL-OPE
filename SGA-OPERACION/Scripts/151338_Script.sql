-- Add/modify columns 
alter table OPERACION.ESTAGENDA add FLG_LIQUIDAMO NUMBER;
-- Add comments to the columns 
comment on column OPERACION.ESTAGENDA.FLG_LIQUIDAMO
  is 'Estado que liquida actividades de MO';

-- Add/modify columns 
alter table OPERACION.ESTAGENDA add FLG_LIQUIDAMAT NUMBER;
-- Add comments to the columns 
comment on column OPERACION.ESTAGENDA.FLG_LIQUIDAMAT
  is 'Estado que liquida Materiales';

-- Add/modify columns 
alter table OPERACION.SOLOTPTOEQU add ESTADOEQU number;
alter table OPERACION.SOLOTPTOEQU add Fec_recupero DATE;
alter table OPERACION.SOLOTPTOEQU add Fec_Almacen DATE;
-- Add comments to the columns 
comment on column OPERACION.SOLOTPTOEQU.ESTADOEQU
  is 'Estado de Equipo';
comment on column OPERACION.SOLOTPTOEQU.Fec_recupero
  is 'Fecha de recupero';
comment on column OPERACION.SOLOTPTOEQU.Fec_Almacen
  is 'Fecha de Almacen';