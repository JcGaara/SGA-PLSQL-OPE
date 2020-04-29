CREATE OR REPLACE PROCEDURE OPERACION.P_VAL_PIDOLD_UPDOWN(a_numslc_dest in operacion.solot.numslc%TYPE,
                                                          a_numslc_ori  in operacion.solot.numslc%TYPE,
                                                          a_msj         out VARCHAR2) IS
  /************************************************************
  NOMBRE:   P_INSERT_NUMSLC_ORI
  PROPOSITO: Valida que todos los servicios del Proyecto al Cual se esta afectando se estan tomando en cuenta
  PROGRAMADO EN JOB: NO
  
  REVISIONES:
  Version   Fecha           Autor               Descripcisn
  --------- ----------      ---------------     ------------------------
  1.0       24/11/2016      Jose Varillas       Alertas Transfer Billing
  ***********************************************************/
  lv_msj VARCHAR2(4000) := ' ';
  ln_val NUMBER;

  Cursor c_pid_updown Is
    select distinct f.pid , a.numslc
      from inssrv              a,
           vtatabcli           b,
           tystabsrv           d,
           estinssrv           e,
           insprd              f,
           tystabsrv           g,
           vtaequcom           h,
           estinsprd           i,
           inssrv              origen,
           inssrv              destino,
           tipinssrv           j,
           solucionesxproducto k,
           producto            m
     where a.numslc = a_numslc_ori
       and g.idproducto = m.idproducto
       and m.flgupgrade = 1
       and a.codcli = b.codcli
       and a.codsrv = d.codsrv
       and a.estinssrv = e.estinssrv
       and a.codinssrv = f.codinssrv
       and f.codsrv = g.codsrv
       and f.codequcom = h.codequcom(+)
       and f.estinsprd = i.estinsprd(+)
       and a.codinssrv_ori = origen.codinssrv(+)
       and a.codinssrv_des = destino.codinssrv(+)
       and a.tipinssrv = j.tipinssrv
       and d.idproducto = k.idproducto
       and k.estado = 1
       and a.estinssrv = 1
       and f.estinsprd = 1
       and f.pid not in
           (Select pid_old from vtadetptoenl where numslc = a_numslc_dest);
BEGIN
  BEGIN
    SELECT COUNT(1)
      INTO ln_val
      FROM OPEDD O, TIPOPEDD T
     WHERE O.TIPOPEDD = T.TIPOPEDD
       AND T.ABREV = 'TRANS_BILL'
       AND O.ABREVIACION = 'P_VAL_PIDOLD_UPDOWN'
       AND O.CODIGOC = '1';
    IF ln_val > 0 THEN
      For lc_pid_updown IN c_pid_updown Loop
        lv_msj := lv_msj || 'Proy. : ' || lc_pid_updown.numslc || ', ' ||
                  'Pid : ' || to_char(lc_pid_updown.pid) || chr(13);
      End Loop;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      lv_msj := ' ';
    
  END;
  a_msj := lv_msj;
END;
/
