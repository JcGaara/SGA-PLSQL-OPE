CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_INT_SOLOT AS

function f_get_id_proceso return number is
/**********************************************************************
Retorna un ID de proceso
**********************************************************************/
tmpvar number;
begin
   select nvl(max(proceso),0)+1 into tmpvar from int_solot;
   return tmpvar;
end;

procedure p_insert_int_solot (
   ar_int_solot in int_solot%rowtype
) is
/**********************************************************************
Inserta un registro en el proceso
**********************************************************************/
l_idseq number;
begin
   select nvl(max(idseq),0)+1 into l_idseq from int_solot;

   insert into int_solot (
      idseq,
      proceso,
      grupo,
      estado,
      estsol,
      codsolot,
      codcli,
      tiptra,
      codinssrv,
      numslc,
      punto,
      recosi,
      pid,
      codmotot,
      tipsrv,
      idproducto,
      tipinssrv,
      codinssrv_des,
      codinssrv_ori,
      fecusu,
      codusu,
      fecusumod,
      codusumod,
      feccom,
      observacion
    ) values (
      l_idseq,
      ar_int_solot.proceso,
      ar_int_solot.grupo,
      nvl(ar_int_solot.estado,0),
      ar_int_solot.estsol,
      ar_int_solot.codsolot,
      ar_int_solot.codcli,
      ar_int_solot.tiptra,
      ar_int_solot.codinssrv,
      ar_int_solot.numslc,
      ar_int_solot.punto,
      ar_int_solot.recosi,
      ar_int_solot.pid,
      ar_int_solot.codmotot,
      ar_int_solot.tipsrv,
      ar_int_solot.idproducto,
      ar_int_solot.tipinssrv,
      ar_int_solot.codinssrv_des,
      ar_int_solot.codinssrv_ori,
      sysdate,
      user,
      sysdate,
      user,
      ar_int_solot.feccom,
      ar_int_solot.observacion );

end;

procedure p_agrupa_proceso (
   a_proceso in number
   ) is
/**********************************************************************
Agrupa los items de un proceso segun
- la logica de PLS FLGENLPRC
- Servicios CENTREX (IS Principal )
- Telefonia ( Hunting, GRupotel, numxgrupotel )
**********************************************************************/

cursor cur_det is
   select * from int_solot
   where proceso = a_proceso;

cursor cur_enl is
   select i.* from int_solot i, producto p
      where i.idproducto = p.idproducto and
      i.proceso = a_proceso
      and p.flgenlprc = 1
      and i.tipinssrv = 2 ;

cursor cur_is_prc is
   select distinct i.codinssrv_pad  from int_solot p, inssrv i
      where
      p.proceso = a_proceso
      and p.codinssrv = i.codinssrv
      and i.codinssrv_pad is not null;

cursor cur_tel is
   select h.codcab, n.codnumtel, n.codinssrv from numtel n, hunting h, operacion.int_solot s
   where n.codnumtel = h.codnumtel and s.codinssrv = n.codinssrv
   and s.proceso = a_proceso
   union all
   select h.codcab, n.codnumtel, n.codinssrv from numtel n, grupotel h, operacion.int_solot s
   where n.codnumtel = h.codnumtel and s.codinssrv = n.codinssrv
   and s.proceso = a_proceso
   union all
   select h.codcab, n.codnumtel, n.codinssrv from numtel n, numxgrupotel h, operacion.int_solot s
   where n.codnumtel = h.codnumtel and s.codinssrv = n.codinssrv
   and s.proceso = a_proceso
   order by 1 ;

l_grupo number;
l_tip number;
l_prd number;
l_sid_ori number;
l_sid_des number;
r_int int_solot%rowtype;
l_cont number;
l_codcab number;

begin
   -- Actualiza los campos basicos de la interface
   l_grupo := 1;
   for d in cur_det loop
      select i.tipinssrv, s.idproducto, i.codinssrv_ori, i.codinssrv_des
      into l_tip, l_prd, l_sid_ori, l_sid_des
         from inssrv i, tystabsrv s
         where i.codsrv = s.codsrv and i.codinssrv = d.codinssrv;
      update int_solot set
         grupo = l_grupo,
         tipinssrv = l_tip,
         idproducto = l_prd,
         codinssrv_ori = l_sid_ori,
         codinssrv_des = l_sid_des
         where proceso = a_proceso;
      l_grupo := l_grupo + 1;
   end loop;

   -- Agrupa enlaces tipo PLS
   for e in cur_enl loop
      select count(*) into l_cont from int_solot
         where proceso = a_proceso
         and codinssrv = e.codinssrv_ori;
      if l_cont = 0 then
         select * into r_int from int_solot where idseq = e.idseq;
         r_int.codinssrv := e.codinssrv_ori;
         r_int.codinssrv_ori := null;
         r_int.codinssrv_des := null;
         r_int.tipinssrv := null;
         r_int.idproducto := null;
         p_insert_int_solot ( r_int );
      else
         update int_solot set grupo = e.grupo
            where proceso = a_proceso
            and codinssrv = e.codinssrv_ori;
      end if;
      select count(*) into l_cont from int_solot
         where proceso = a_proceso
         and codinssrv = e.codinssrv_des;
      if l_cont = 0 then
         select * into r_int from int_solot where idseq = e.idseq;
         r_int.codinssrv := e.codinssrv_des;
         r_int.codinssrv_ori := null;
         r_int.codinssrv_des := null;
         r_int.tipinssrv := null;
         r_int.idproducto := null;
         p_insert_int_solot ( r_int );
      else
         update int_solot set grupo = e.grupo
            where proceso = a_proceso
            and codinssrv = e.codinssrv_des;
      end if;
   end loop;

   -- Logica CENTREX - PIA
   for p in cur_is_prc loop
      update int_solot set grupo = l_grupo
         where proceso = a_proceso
         and codinssrv in (select codinssrv from inssrv where codinssrv_pad = p.codinssrv_pad);
      update int_solot set grupo = l_grupo
         where proceso = a_proceso
         and codinssrv =  p.codinssrv_pad;
      l_grupo := l_grupo + 1;
   end loop;

   -- Logica CENTREX - PIA
   l_codcab := null;
   for h in cur_tel loop
      if l_codcab = h.codcab then
         null;
      else
         l_codcab := h.codcab;
         l_grupo := l_grupo + 1;
      end if;
      update int_solot set grupo = l_grupo
         where proceso = a_proceso
         and codinssrv =  h.codinssrv;
   end loop;

end;

procedure p_exe_proceso (
   a_proceso in number
   ) is
/**********************************************************************
Ejecuta todo el proceso
- Agrupa
- Genera las SOT del proceso
**********************************************************************/
begin
   p_agrupa_proceso(a_proceso);
   p_crear_solot(a_proceso);
end;

procedure p_crear_solot (
   a_proceso in number
   ) is
/**********************************************************************
Genera las SOT del proceso
**********************************************************************/
cursor cur_grp is
   select grupo from int_solot
   where proceso = a_proceso
   group by grupo;

l_codsolot number;
ln_tiptra number;
ln_motivo number;
ln_cont number(3);

r_solot solot%rowtype;
r_det int_solot%rowtype;
l_tiptra tiptrabajo.tiptra%type;

begin

   for s in cur_grp loop
      l_codsolot := null;
      -- Se obtiene los datos para una s
      select * into r_det from int_solot
         where  proceso = a_proceso
         and grupo = s.grupo and rownum = 1;


      r_solot.tiptra := r_det.tiptra;
      r_solot.codmotot := r_det.codmotot;
      r_solot.estsol := 10;
      r_solot.tipsrv := r_det.tipsrv;
      r_solot.numslc := r_det.numslc;
      r_solot.codcli := r_det.codcli;
      r_solot.feccom := r_det.feccom;
      r_solot.recosi := r_det.recosi;
      r_solot.observacion := r_det.observacion;

      pq_solot.p_insert_solot( r_solot, l_codsolot );

      -- Se asigna las SOLOT
      update int_solot set codsolot = l_codsolot
         where proceso = a_proceso and grupo = s.grupo ;

      p_crear_solotpto(a_proceso, l_codsolot);

      -- Se podria aprobar la solicitud
      if r_det.estsol <> 10 then
         PQ_SOLOT.p_chg_estado_solot (l_codsolot, r_det.estsol);
      end if;

   end loop;

end;

procedure p_crear_solotpto (
   a_proceso in number,
   a_codsolot in number
)
/**********************************************************************
Genera el detalle de la SOT del proceso
**********************************************************************/
IS

r_solotpto solotpto%rowtype;
l_punto solotpto.punto%type;
r_inssrv inssrv%rowtype;
l_codsrvnue insprd.CODSRV%type;
cursor cur_det is
   select * from int_solot
      where proceso = a_proceso and codsolot = a_codsolot ;

begin

   for r_det in cur_det loop
      select * into r_inssrv from inssrv where codinssrv = r_det.codinssrv;
      begin
      select p.codsrv into l_codsrvnue from insprd p where p.pid = r_det.pid;
      exception when others then
        l_codsrvnue := null;
      end;
      r_solotpto.codsolot := r_det.codsolot;
      --r_solotpto.punto := r_det.punto;
      r_solotpto.tiptrs := null;
      r_solotpto.codsrvnue := l_codsrvnue;
      r_solotpto.bwnue := r_inssrv.bw;
      r_solotpto.codinssrv := r_det.codinssrv;
      r_solotpto.cid := r_inssrv.cid;

      r_solotpto.descripcion := r_inssrv.descripcion;
      r_solotpto.direccion := r_inssrv.direccion;
      r_solotpto.tipo := 2;
      r_solotpto.estado := 1;
      r_solotpto.visible := 1;
      r_solotpto.codubi := r_inssrv.codubi;
      r_solotpto.pid := r_det.pid;
      r_solotpto.codpostal := r_inssrv.codpostal ;

      pq_solot.p_insert_solotpto( r_solotpto, l_punto );

   end loop;
end;

END;
/
