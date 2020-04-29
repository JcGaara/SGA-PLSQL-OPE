-- Add/modify columns 
alter table OPERACION.TIPEQU add FLG_PORTAL_CAUTIVO char(1) default 0;
-- Add comments to the columns 
comment on column OPERACION.TIPEQU.FLG_PORTAL_CAUTIVO
  is '1= Equipo compatible con Portal Cautivo';

update operacion.tipequ t
   set t.flg_portal_cautivo = 1
 where t.tipequ = '10388';
commit;