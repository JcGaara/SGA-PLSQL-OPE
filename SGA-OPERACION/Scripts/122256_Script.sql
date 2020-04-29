-- Add/modify columns 
alter table TELEFONIA.NUMTEL add IMEI varchar2(100);
alter table TELEFONIA.NUMTEL add SIMCARD varchar2(100);
comment on column TELEFONIA.NUMTEL.IMEI
  is 'IMEI';
comment on column TELEFONIA.NUMTEL.SIMCARD
  is 'SIMCARD';

-- Add/modify columns 
alter table HISTORICO.TEL_NUMTEL_LOG add IMEI varchar2(100);
alter table HISTORICO.TEL_NUMTEL_LOG add SIMCARD varchar2(100);
-- Add comments to the columns 
comment on column HISTORICO.TEL_NUMTEL_LOG.IMEI
  is 'IMEI';
comment on column HISTORICO.TEL_NUMTEL_LOG.SIMCARD
  is 'SIMCARD';