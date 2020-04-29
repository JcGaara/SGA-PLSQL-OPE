CREATE OR REPLACE PROCEDURE OPERACION.P_ASIGNACION_NUMERO(a_idtareawf in number,
                                                          a_idwf      in number,
                                                          a_tarea     in number,
                                                          a_tareadef  in number) IS
/********************************************************************************
     NOMBRE: P_ASIGNACION_NUMERO
     PROPOSITO:Asigna el numero telefonico, para el caso de traslado externo
     Creacion
     Ver     Fecha          Autor              Descripcion
    ------  ----------  ----------            --------------------
     1.0     14/05/2009  Hector Huaman M      REQ-92608:Se modifico  procedimiento para considerar proyectos GSM
     2.0     16/07/2009  Hector Huaman M      REQ-97545:se hizo el cambio que solo actualizara  el numero en inssrv para los translados
 ********************************************************************************/
  l_codsolot solot.codsolot%type;
  l_numero   inssrv.numero%type;

  CURSOR c2 IS
    select s.codinssrv, s.codinssrv_tra
      from solotpto s, inssrv i, tystabsrv t
     where s.codinssrv = i.codinssrv
       and t.codsrv = s.codsrvnue
       and i.numero is null
       and t.idproducto not in (524)
       and s.codsolot = l_codsolot;
 --<1.0
  CURSOR c_gsm IS
  select  r.numtel numero, p.codinssrv
  from  sales.reginfcdma r,solot s, solotpto p
     where r.numslc=s.numslc and
     s.codsolot=p.codsolot and
     s.codsolot=l_codsolot;
--1.0>
BEGIN
  select codsolot into l_codsolot from wf where idwf = a_idwf;
   for r_det in c2 loop
    if r_det.codinssrv_tra is not null then
      -- para traslados
      select numero
        into l_numero
        from inssrv
       where codinssrv = r_det.codinssrv_tra;

      update inssrv
         set numero = l_numero
       where codinssrv = r_det.codinssrv;
      --<2.0
      /*update numtel
         set codinssrv = r_det.codinssrv
       where codinssrv = r_det.codinssrv_tra;*/ --2.0>

    end if;
  end loop;
 --<1.0
   for r_gsm in c_gsm loop

      update inssrv
         set numero = r_gsm.numero
       where codinssrv = r_gsm.codinssrv;

      update numtel
         set codinssrv = r_gsm.codinssrv
       where codinssrv =  r_gsm.numero;
  end loop;
--1.0>
END;
/


