CREATE OR REPLACE PACKAGE OPERACION.pq_migracion_dth is

  -- Author  : ANTONIO.LAGOS
  -- Created : 10/09/2010 05:49:54 p.m.
  -- Purpose : migracion

  WFBAJA      NUMBER(8) := 939; --wf de baja DTH, actualizar en PRD
  WFINST      NUMBER(8) := 917; --wf de instalacion DTH, actualizar en PRD
  --TIPTRABAJA  NUMBER(4) := 503; --tipo de trabajo de baja, actualizar en PRD
 --- procedure p_migra_reginsdth;

  procedure p_reasigna_wf(an_tipo number);

end pq_migracion_dth;
/


