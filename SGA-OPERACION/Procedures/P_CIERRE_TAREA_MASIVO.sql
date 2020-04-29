CREATE OR REPLACE PROCEDURE OPERACION.P_CIERRE_TAREA_MASIVO is
/*
       Creado por Enrique Melendez. Cierre de tareas masivo
       Modificado 13/06/2008
*/
CURSOR c1 IS
SELECT v_tareawf.idtareawf
FROM v_tareawf, wf, solot
Where v_tareawf.idwf = wf.idwf
      and wf.codsolot = solot.codsolot and v_tareawf.esttarea = 1
      and solot.tiptra not in (416,418,412,406,411,415,410,407,417,404,409,414,413,408,405)
      and to_char(solot.fecusu,'YYYY') < 2007 -- Solo las del 2006 hacia abajo
      and not v_tareawf.tareadef = 299 -- No las de Activacion/esactivacion Servicio
      and v_tareawf.idtareawf not  in ('244343','284219')
      order by v_tareawf.idtareawf;
Begin
    FOR reg IN c1 LOOP
        -- Call the procedure --
        opewf.pq_wf.P_CHG_STATUS_TAREAWF  ( reg.idtareawf ,4,4,null,sysdate,sysdate );
        Commit;
    END LOOP;
    Commit;
End;
/


