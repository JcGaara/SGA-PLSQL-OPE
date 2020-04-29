-- Add/modify columns 
alter table OPERACION.CONTRACT_BAJA_DTH_POST add actionid number;
alter table OPERACION.BAJA_DTH_POS add action number;
alter table OPERACION.OPE_TVSAT_SLTD_DET add action_id number;
alter table OPERACION.CONTRACT_ALTA_DTH_POST add actionid number;
alter table OPERACION.RECONEXION_DTH_POS add action number;
-- Add comments to the columns 
comment on column OPERACION.CONTRACT_BAJA_DTH_POST.actionid
  is 'ActionId proveniente de BSCS gmd_action';
comment on column OPERACION.BAJA_DTH_POS.action
  is 'ActionId proveniente de BSCS gmd_action';  
comment on column OPERACION.OPE_TVSAT_SLTD_DET.action_id
  is 'ActionId que proviene de BSCS gmd_action';
comment on column OPERACION.CONTRACT_ALTA_DTH_POST.actionid
  is 'ActionId proveniente de BSCS gmd_action';
comment on column OPERACION.RECONEXION_DTH_POS.action
  is 'ActionId proveniente de BSCS gmd_action';