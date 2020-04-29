---adicionar campos
alter table operacion.tab_hfc_alineacion add codusu VARCHAR2(25) default USER; 
alter table operacion.tab_hfc_alineacion add fecusu DATE default SYSDATE; 
commit;
