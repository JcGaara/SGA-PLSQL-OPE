create or replace procedure operacion.p_pendiente_asig_numero is
/*Para las HFC masivo y  HFC CE Portabilidad y no Portabilidad*/
  cursor c_ is
    select s.codsolot,
           wf.idwf,
           s.tipsrv,
           i.numslc,
           i.numero,
           (select a.estage from agendamiento a where a.codsolot = s.codsolot),
           (select descripcion
              from estagenda
             where estage in (select a.estage
                                from agendamiento a
                               where a.codsolot = s.codsolot))
      from solot s, vtatabslcfac c, inssrv i, wf
     where s.tiptra = 424
       and s.estsol = 17
       and wf.codsolot = s.codsolot
       and i.numslc = c.numslc
       and i.tipinssrv = 3
       and s.numslc = c.numslc
       and c.flg_portable in (1, 0)
       and i.numero is null;
begin
  for a in c_ loop
    begin
    operacion.p_asig_numtelef_wf(null, a.idwf, null, null);
    exception
       when others then
         null;
     end;    
  end loop;
end  p_pendiente_asig_numero;
/
