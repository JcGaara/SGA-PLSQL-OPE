CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_PERMISOS AS

FUNCTION seg_concluir_ot(a_codot in Number ) Return Number IS
BEGIN
   return 1;
   EXCEPTION WHEN others THEN return 0;
END;

FUNCTION seg_anular_ot(a_codot in Number ) Return Number IS
BEGIN
   return 1;
   EXCEPTION WHEN others THEN return 0;
END;

FUNCTION seg_aprobar_solot(a_codsolot in Number ) Return Number IS
BEGIN
   return 1;
   EXCEPTION WHEN others THEN return 0;
END;

FUNCTION seg_anular_solot(a_codsolot in Number ) Return Number IS
BEGIN
   return 1;
   EXCEPTION WHEN others THEN return 0;
END;

END PQ_PERMISOS;
/


