CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_DES_CID_INTERNOS(an_idtareawf in number,
                                                             an_idwf      in number,
                                                             an_tarea     in number,
                                                             an_tareadef  in number) IS
  /******************************************************************************
  POS
  Tarea: Activar y Desativar CID Backbone
  Modifica el estado de los CIDs asociados a la SOT a Activo o Desactivado
  ******************************************************************************/
  ln_codsolot      number;
  ln_tiptrs        number;
  ln_cont_tareacfg number;

BEGIN
  select count(1)
    into ln_cont_tareacfg
    from opedd
   where tipopedd = 282
     and an_tareadef = codigon;

  if ln_cont_tareacfg = 1 then
    select wf.codsolot, tip.tiptrs
      into ln_codsolot, ln_tiptrs
      from wf, solot sot, tiptrabajo tip
     where sot.tiptra = tip.tiptra
       and wf.codsolot = sot.codsolot
       and wf.idwf = an_idwf;
  
    if ln_tiptrs = 1 then
    
      Update inssrv
         set estinssrv = 1
       where codinssrv IN (select a.codinssrv
                             from solotpto a, inssrv b
                            where a.codsolot = ln_codsolot
                              and a.codinssrv = b.codinssrv
                              and b.estinssrv in (4));
    
      Update acceso
         set estado = 1
       where CID IN (select a.CID
                       from solotpto a, acceso b
                      where a.codsolot = ln_codsolot
                        and a.cid = b.cid
                        and b.estado in (0, 2));
    elsif ln_tiptrs = 5 then
    
      Update inssrv
         set estinssrv = 3
       where codinssrv IN (select a.codinssrv
                             from solotpto a, inssrv b
                            where a.codsolot = ln_codsolot
                              and a.codinssrv = b.codinssrv
                              and b.estinssrv in (1));
    
      Update acceso
         set estado = 0
       where CID IN (select a.CID
                       from solotpto a, acceso b
                      where a.codsolot = ln_codsolot
                        and a.cid = b.cid
                        and b.estado in (1));
    
    end if;
  end if;
END;
/
