CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_SEGPROYECTO AS
/******************************************************************************
   NAME:       PQ_BOD
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        13/12/2006  LUIS OLARTE      1. Created this package.
******************************************************************************/


/**********************************************************************
Inserta registros en la tabla INSSRV del portal
**********************************************************************/
PROCEDURE P_ACT_SOTS IS

CURSOR cwfs IS
select distinct idwf from operacion.restarwf where feccom is null and idwf <> 26145;

BEGIN
 FOR c1_cwfs IN cwfs LOOP
          P_ACTUALIZA_WF (c1_cwfs.idwf);
          commit;
      END LOOP;


END P_ACT_SOTS;



PROCEDURE P_ACTUALIZA_WF(
	a_idwf in number
) IS

CURSOR ctarea IS
select *
from restarwf r
where
r.idwf = a_idwf and
r.feccom is not null and
r.fecfin is null and
r.pos_tareas is not null;

BEGIN
 FOR c1_tarea IN ctarea LOOP
          P_CREA_POS_TAREAWF (c1_tarea.idtareawf,c1_tarea.tarea,c1_tarea.pos_tareas,c1_tarea.plazo,c1_tarea.feccom);
      END LOOP;


END P_ACTUALIZA_WF;


PROCEDURE P_CREA_POS_TAREAWF(
	a_idtareawf in number,
	a_tarea in number,
	a_pos_tareas in char,
  a_plazo in number,
  a_feccom in date
) IS
	v_tarea varchar2(20);
	n_idwf tareawfcpy.idwf%type;
	v_pos_tareas tareawfcpy.pos_tareas%type;
	n_idtareawf tareawfcpy.idtareawf%type;
    n_tarea  number;
  n_plazo  number;
    n_pos_tareas  varchar2(100);
    n_feccom date;

BEGIN
   v_pos_tareas:= a_pos_tareas;
   select idwf into n_idwf from restarwf where idtareawf = a_idtareawf;
   while INSTR(v_pos_tareas,';') <> 0 loop
      v_tarea:= SUBSTR(v_pos_tareas,1,INSTR(v_pos_tareas,';')-1);
      v_pos_tareas:= SUBSTR(v_pos_tareas, INSTR(v_pos_tareas,';')+1, LENGTH(v_pos_tareas));
      --select idtareawf into n_idtareawf from restarwf where idwf= n_idwf and tarea=v_tarea;
     -- update restarwf r set r.feccom = a_feccom + a_plazo where idtareawf = n_idtareawf;

         select idtareawf, pos_tareas, tarea, plazo ,feccom
         into n_idtareawf, n_pos_tareas, n_tarea, n_plazo  ,n_feccom
         from restarwf where idwf= n_idwf and tarea=v_tarea;


      if ((n_feccom is null) or  (n_feccom < F_ADD_DIAS_UTILES(a_feccom,n_plazo))) then
   update restarwf r set r.feccom =  F_ADD_DIAS_UTILES(a_feccom,n_plazo) where idtareawf = n_idtareawf;
   end if;


   if n_pos_tareas is not null then
   P_CREA_POS_TAREAWF(n_idtareawf,n_tarea,n_pos_tareas,n_plazo, F_ADD_DIAS_UTILES(a_feccom,n_plazo));
   end if;


     -- P_GENERA_TAREA(n_idwf,v_tarea,n_idtareawf);
   end loop;

   select idtareawf, pos_tareas, tarea, plazo ,feccom
   into n_idtareawf, n_pos_tareas, n_tarea, n_plazo,n_feccom
   from restarwf where idwf= n_idwf and tarea=v_pos_tareas;

   if ((n_feccom is null) or  (n_feccom < F_ADD_DIAS_UTILES(a_feccom,n_plazo))) then
    update restarwf r set r.feccom = F_ADD_DIAS_UTILES(a_feccom,n_plazo) where idtareawf = n_idtareawf;
   end if;

   update restarwf r set r.feccom = F_ADD_DIAS_UTILES(a_feccom,n_plazo) where idtareawf = n_idtareawf;
   if n_pos_tareas is not null then
   P_CREA_POS_TAREAWF(n_idtareawf,n_tarea,n_pos_tareas,n_plazo, F_ADD_DIAS_UTILES(a_feccom,n_plazo));
   end if;
   --P_GENERA_TAREA(n_idwf,v_pos_tareas,n_idtareawf);
   /*EXCEPTION
     WHEN NO_DATA_FOUND THEN
       Null;
     WHEN OTHERS THEN
       Null;*/
END P_CREA_POS_TAREAWF;

END PQ_SEGPROYECTO;
/


