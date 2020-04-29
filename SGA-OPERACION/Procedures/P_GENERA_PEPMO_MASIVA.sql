CREATE OR REPLACE PROCEDURE OPERACION.P_GENERA_PEPMO_MASIVA
AS

/* Autor: Enrqiue Melendez 05/05/2008
   Generación auntomàtica de elementos PEP de mano de obra desde EF en forma masiva

*/

PN_SOL           NUMBER;

cursor c_solot Is
select numslc, codsolot, codusu from operacion.tmp_gen_masiva_pep_moef
where estado = '0' ;

BEGIN
  for reg in c_solot loop
      financial.pq_z_ps_proyectossap.p_screa_def_pep_sotmo(reg.numslc ,reg.codsolot,'PER',pn_sol);
      COMMIT;
      UPDATE operacion.tmp_gen_masiva_pep_moef SET TRANSACCION = PN_SOL, ESTADO = '1' WHERE CODSOLOT = REG.CODSOLOT AND NUMSLC = REG.NUMSLC AND ESTADO = '0';
      COMMIT;
  end loop;
  COMMIT;
END;
/


