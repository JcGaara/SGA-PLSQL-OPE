CREATE OR REPLACE PROCEDURE OPERACION.p_ejecuta_activ_desactiv(n_codsolot solot.codsolot%type, v_tareadef number, d_fecusu date)
is
 /************************************************************
  NOMBRE:     P_EJECUTA_ACTIV_DESACTIV
  PROPOSITO:  Activar / Desactivar los servicios
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version      Fecha        Autor           Descripcisn
  ---------  ----------  ---------------  ------------------------

  1.0        13/04/2009  Hector Huaman    REQ-89542: se añadio la excepcion para enviar correo cuando ocurre un error.
  ***********************************************************/
------------------------------------

  l_idwf wf.idwf%type;
  l_idtareawf tareawf.idtareawf%type;
  p_codsolot  solot.codsolot%type;
  l_var varchar2(200);

  cursor c_trssolot is
    select codtrs, fectrs, esttrs, codsolot, codinssrv, pid
      from trssolot
     where codsolot = p_codsolot;

begin
select idwf into l_idwf from wf where codsolot = n_codsolot and valido=1; -- Se filtra el workflow válido

for lc_tareacpy in (select idtareawf from tareawfcpy where idwf = l_idwf) loop
    l_idtareawf := lc_tareacpy.idtareawf;
    for lc_tarea in (select idtareawf, ESTTAREA, TAREADEF
                       from tareawf
                      where idwf = l_idwf
                        and idtareawf = l_idtareawf) loop

          if lc_tarea.esttarea = 1 and lc_tarea.TAREADEF = v_tareadef then
                -- Crea los registro de transaccion para la aprobacion en contrato

                OPERACION.pq_solot.p_crear_trssolot(4, n_codsolot, null, null, null, null);
                p_codsolot := n_codsolot;
                for lc_trssolot in c_trssolot loop
                    operacion.pq_solot.p_exe_trssolot(lc_trssolot.codtrs,
                                                      2,
                                                      d_fecusu);

                    update solotpto set fecinisrv = d_fecusu
                    where codinssrv = lc_trssolot.codinssrv
                    and codsolot = lc_trssolot.codsolot
                    and fecinisrv is null
                    and pid is null;

                    update solotpto set fecinisrv = d_fecusu
                    where pid=lc_trssolot.pid
                    and codsolot = lc_trssolot.codsolot
                    and fecinisrv is null;

                end loop;

                if l_idtareawf is not null then
                  opewf.pq_wf.P_CHG_STATUS_TAREAWF(l_idtareawf,
                                                   4,
                                                   4,
                                                   0,
                                                   sysdate,
                                                   sysdate);
            end if;

          end if;
    end loop;

end loop;
--REQ-89542:
exception
     WHEN OTHERS THEN
        raise_application_error(-20000,' Error en el procedimiento operacion.p_ejecuta_activ_desactiv en la SOT : ' || n_codsolot );
        ROLLBACK;

end;
/


