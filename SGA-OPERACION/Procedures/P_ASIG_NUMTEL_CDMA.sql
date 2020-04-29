CREATE OR REPLACE PROCEDURE OPERACION.p_asig_numtel_cdma(a_idtareawf in number,
                                                         a_idwf      in number,
                                                         a_tarea     in number,
                                                         a_tareadef  in number) is

  /***********************************************************************************************
    NOMBRE:      operacion.p_asig_numtel_cdma
    PROPOSITO:   Actualizacion de la Simcar

    REVISIONES:
    Ver    Fecha          Autor            Solicitado por           Description
    ------ ----------    ---------------   ---------------------    -----------------------------
    1.0    14/11/2009    Jimmy Farfán      Req. 97766               Proc. Pos, para la tarea de asignación de números GSM y CDMA.
    2.0    07/05/2010    Edson Caqui       Req. 127310
  ***********************************************************************************************/

  n_codcab       number;
  n_estinssrv    inssrv.estinssrv%type;
  l_codnumtel    numtel.codnumtel%type;
  l_codinssrv    inssrv.codinssrv%type;
  l_codsolot     solot.codsolot%type;
  v_numero       numtel.numero%type;
  v_mensaje1     varchar2(500);
  v_imsi         simcar.imsi%type;
  ln_idaccesorio trsequi_sim.idaccesorio%type;
  ln_codcab      number;

begin

  select codsolot into l_codsolot from wf where idwf = a_idwf;

  begin
    select inssrv.codinssrv, inssrv.numero, numtel.codnumtel
      into l_codinssrv, v_numero, l_codnumtel
      from inssrv, numtel
     where inssrv.numero = numtel.numero
       and inssrv.numslc =
           (select numslc from solot where codsolot = l_codsolot)
       and tipinssrv = 3;
  exception
    when others then
      raise_application_error(-20500,
                              'Debe realizar la reserva del Número Telefónico y del terminal.');
  end;

  --<2.0>
  begin
    select s.imsi
      into v_imsi
      from inssrv r, simcar s
     where s.estado = 4
       and r.numero = s.numero
       and r.numslc =
           (select numslc
              from solot
             where codsolot = (select codsolot from wf where idwf = a_idwf));
  exception
    when no_data_found then
      raise_application_error(-20500,
                              'No se asocio Simcar al numero' || v_numero);
    when too_many_rows then
      raise_application_error(-20500,
                              'Se tiene mas de una Simcar asociada al numero' ||
                              v_numero);
  end;
  --</2.0>

  update simcar set estado = 5 where imsi = v_imsi;

  begin
    select t.idaccesorio
      into ln_idaccesorio
      from trsequi_sim t, simcar s
     where t.imsi = s.imsi
       and t.imsi = v_imsi;
  exception
    when no_data_found then
      null;
  end;

  update sales.accesorio set estado = 2 where idaccesorio = ln_idaccesorio;

  update numtel
     set estnumtel = 2,
         fecasg    = sysdate,
         codinssrv = l_codinssrv,
         codusuasg = user
   where codnumtel = l_codnumtel;

  update solotpto set fecinisrv = sysdate where codsolot = l_codsolot; -- Se asigna la fecha de inicio del servicio

  select i.estinssrv
    into n_estinssrv
    from inssrv i
   where i.codinssrv = l_codinssrv;

  update inssrv set estinssrv = 4 where codinssrv = l_codinssrv;

  telefonia.pq_telefonia.p_crear_hunting(l_codnumtel, ln_codcab);

  update inssrv set estinssrv = n_estinssrv where codinssrv = l_codinssrv;

  commit;

exception
  when others then
    raise_application_error(-20500,
                            'No se proceso asignación de número telefónico. ' ||
                            sqlerrm);

end;
/


