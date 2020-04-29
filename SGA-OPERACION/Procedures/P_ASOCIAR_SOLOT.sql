CREATE OR REPLACE PROCEDURE OPERACION.P_ASOCIAR_SOLOT(
   a_codsolot1 in number,
   a_codsolot2 in number
) IS

l_to number;
l_from number;
l_punto number;
l_cnt_equ number;
l_cnt_trs number;
l_idwf number;
l_cont number;
l_tip number;
l_maximo number;

begin
  l_to := a_codsolot1;
  l_from := a_codsolot2;


  select count(*) into l_cnt_equ from solotptoequ
  where codsolot = l_from;

  select count(*) into l_cnt_trs from trssolot
  where codsolot = l_from;

  select estsol.tipestsol into l_tip from solot s, estsol
     where s.estsol = estsol.estsol and s.codsolot = l_from;
  if l_tip in (4,5) then
     raise_application_error(-20500, 'Solicitud OT: '||trim(to_char(l_from))||' no esta habilitada para el cambio.');
  end if;

  l_idwf := f_get_wf_solot(l_from,1);
  if (l_cnt_equ = 0) and (l_cnt_trs = 0) then
     if l_idwf is not null then
        select count(*) into l_cont from tareawf where idwf = l_idwf and tipesttar = 4;
        if l_cont > 0 then
           raise_application_error(-20500, 'Solicitud OT: '||trim(to_char(l_from))||' tiene tareas asociadas');
        else
           pq_wf.P_CANCELAR_WF(l_idwf);
        end if;
     end if;
     -- Se anula las SOTs
     select nvl(max(punto),0) into l_punto from solotpto where codsolot = l_to;
     insert into solotpto (
        codsolot, punto, tiptrs, codsrvant, bwant, codsrvnue, bwnue, codusu, fecusu, codinssrv, cid, descripcion, direccion, tipo, estado, visible, puerta, pop, codubi, fecini, fecfin, fecinisrv, feccom, tiptraef, tipotpto, efpto, pid, pid_old, cantidad, codpostal, flgmt, codinssrv_tra)
     select
        l_to , punto + l_punto, tiptrs, codsrvant, bwant, codsrvnue, bwnue, codusu, fecusu, codinssrv, cid, descripcion, direccion, tipo, estado, visible, puerta, pop, codubi, fecini, fecfin, fecinisrv, feccom, tiptraef, tipotpto, efpto, pid, pid_old, cantidad, codpostal, flgmt, codinssrv_tra
     from solotpto where codsolot = l_from;

     delete solotptoeta where codsolot = l_from;
     delete solotpto_id_historico where codsolot = l_from;
     delete preubi where codsolot = l_from;
     delete solotpto where codsolot = l_from;

     pq_solot.p_chg_estado_solot(l_from, 13);

	 --Observacion que se ingresa al anular la solicitud.

	 select nvl(max(idseq),0) into l_maximo from solotchgest;

	 update solotchgest
	 	set observacion =  observacion || 'SE ANULO PORQUE SE ATENDIO CON LA SOT ' || to_char(l_to) || ' LA CUAL SE ASOCIARON LAS SOTs ANULADAS'
		where idseq = l_maximo;
	 --


  elsif l_cnt_equ > 0 then
     raise_application_error(-20500, 'Solicitud OT: '||trim(to_char(l_from))||' tiene equipos asociados');
  elsif l_cnt_trs > 0 then
     raise_application_error(-20500, 'Solicitud OT: '||trim(to_char(l_from))||' tiene transacciones generadas');
  end if;
end;
/


