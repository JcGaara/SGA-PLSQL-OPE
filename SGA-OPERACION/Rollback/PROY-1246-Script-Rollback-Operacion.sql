---- drop indexes

DROP INDEX OPERACION.IDX_SOLOT_07;


-- drop sequence 
drop sequence OPERACION.SQ_OPE_TIPOMASIVASOT_MAE;
drop sequence OPERACION.SQ_OPE_MASIVASOT_CAB;
drop sequence OPERACION.SQ_OPE_MASIVASOT_DET;

---- drop Tables

drop table operacion.Ope_masivasot_det;
drop table operacion.ope_masivasot_cab;
drop table operacion.ope_tipomasivasot_mae;

---- drop Triggers

DROP TRIGGER OPERACION.T_OPE_TIPOMASIVASOT_MAE_BI; 
DROP TRIGGER OPERACION.T_OPE_TIPOMASIVASOT_MAE_BU; 
DROP TRIGGER OPERACION.T_OPE_TIPOMASIVASOT_MAE_AIUD;
DROP TRIGGER OPERACION.T_OPE_MASIVASOT_CAB_BI; 
DROP TRIGGER OPERACION.T_OPE_MASIVASOT_CAB_BU; 
DROP TRIGGER OPERACION.T_OPE_MASIVASOT_CAB_AIUD;
DROP TRIGGER OPERACION.T_OPE_MASIVASOT_DET_BI; 
DROP TRIGGER OPERACION.T_OPE_MASIVASOT_DET_BU; 
DROP TRIGGER OPERACION.T_OPE_MASIVASOT_DET_AIUD;


---- drop packages body 
drop package body operacion.pq_masivasot;

---- drop packages

drop package operacion.pq_masivasot;


