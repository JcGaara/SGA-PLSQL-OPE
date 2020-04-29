create or replace trigger OPERACION.T_OPE_TECNICOSCONTRATA_REL_BI
  before insert on OPERACION.OPE_TECNICOSCONTRATA_REL
  for each row
/******************************************************************************
     NAME:       T_OPE_TECNICOSCONTRATA_REL_BI
     PURPOSE:
  
     REVISIONS:
     Ver        Date        Author           Solicitado por  Description
     ---------  ----------  ---------------  --------------  ------------------------------------
  
      1        06/09/2011  Alfonso Pérez      Elver Ramirez  REQ 159092, Triguer de OPE_TECNICOSCONTRATA_REL
  *********************************************************************/

declare
  ln_id number;
begin
  select operacion.SQ_TECNICOSCONTRATA_REL.Nextval into ln_id from dummy_ope;
  :new.ID_TECNICO := ln_id;
end;
/