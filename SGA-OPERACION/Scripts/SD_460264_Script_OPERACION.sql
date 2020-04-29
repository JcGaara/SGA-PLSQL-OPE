-- Add/modify columns 
alter table OPERACION.TRS_WS_SGA add REPORTOBJOUTPUT VARCHAR2(4000);
alter table OPERACION.TRS_WS_SGA add DOCSISREPORT VARCHAR2(4000);
alter table OPERACION.TRS_WS_SGA add PACKETCABLEREPORT VARCHAR2(4000);
alter table OPERACION.TRS_WS_SGA add DAC VARCHAR2(4000);
-- Add comments to the columns 
comment on column OPERACION.TRS_WS_SGA.REPORTOBJOUTPUT
  is 'REPORTOBJOUTPUT del WS';
comment on column OPERACION.TRS_WS_SGA.DOCSISREPORT
  is 'DOCSISREPORT del WS';
comment on column OPERACION.TRS_WS_SGA.PACKETCABLEREPORT
  is 'PACKETCABLEREPORT del WS';
comment on column OPERACION.TRS_WS_SGA.DAC
  is 'DAC del WS';
