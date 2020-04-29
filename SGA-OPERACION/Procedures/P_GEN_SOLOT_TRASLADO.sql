
CREATE OR REPLACE PROCEDURE OPERACION.p_gen_solot_traslado (
   a_codsolot in number
) is

  /************************************************************
  NOMBRE:     P_GEN_SOLOT_TRASLADO
  PROPOSITO:  Genera las SOT de traslado en base a una SOT
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version      Fecha        Autor           Descripcisn
  ---------  ----------  ---------------  ------------------------
  1.0        05/11/2003  C.Corrales        REQ-97131:Update a las SOTs para que lleguen con el area y usuario de quien genero la SOT original
  2.0        16/07/2009  Hector Huaman M   REQ-97545:se actualiza  el codinssrv en la tabla numtel
  3.0        20/01/2014  Carlos Lazarte    RQM 164660 - Migracion Traslados Externos
  4.0        20/01/2014  Jorge Armas       SD 73474 - NO SE ESTA GENERANDO POT TRASLADO EXTERNO SOT DE DESACTIVACION POR SUSTITUCION
  ***********************************************************/

Cursor cur_pto is
   select distinct codinssrv, codinssrv_tra, pid_old 
   from solotpto pto, solot sot 
   where pto.codsolot = a_codsolot --4.0 se agrego pid_old
     and pto.codsolot = sot.codsolot
     and pto.codinssrv_tra is not NULL; --4.0

r_solot solot%rowtype;
r_int_solot int_solot%rowtype;
l_proceso number;
l_cont number;
l_obs int_solot.observacion%type;
l_num inssrv.numero%type;

begin

   select count(*) into l_cont from solotpto where codsolot = a_codsolot
   and codinssrv_tra is not null;
   if l_cont > 0 then
      select *  into r_solot from solot where codsolot = a_codsolot;

     -- 4.0 Se filtra solo los traslados externos por tipo de trabajo
     select count(*) into l_cont
      from tipopedd  tp, opedd od
     where TP.ABREV = 'TRASLADO_EXTERNO'
       and TP.TIPOPEDD = od.TIPOPEDD
       and od.codigoN = r_solot.tiptra;
       
     if l_cont > 0  then 

       l_proceso := pq_int_solot.f_get_id_proceso;

       r_int_solot.proceso := l_proceso;
       r_int_solot.codcli := r_solot.codcli;
       r_int_solot.tiptra := 7;
       r_int_solot.estsol := 11;
       r_int_solot.numslc := r_solot.numslc;
       --r_int_solot.recosi := r_solot.recosi;
       --r_int_solot.motot := r_solot.motot;
       r_int_solot.tipsrv := r_solot.tipsrv;
       r_int_solot.feccom := sysdate + 7;


       for r_pto in cur_pto loop
         begin
            select numero into l_num from inssrv where codinssrv = r_pto.codinssrv;
            l_obs := 'SOT generada por la activacion de '||l_num;
            l_obs := l_obs||chr(13)||'Proyecto '|| r_solot.numslc;
            l_obs := l_obs||', SOT '|| r_solot.codsolot;
            --<2.0
            update numtel
               set codinssrv = r_pto.codinssrv,
                   estnumtel = 2   --3.0
             where numero=l_num;
            --2.0>
         exception
            when others then
               l_obs := null;
         end;

         r_int_solot.observacion := l_obs;
         r_int_solot.codinssrv := r_pto.codinssrv_tra;
         r_int_solot.pid := r_pto.pid_old; --3.0

         pq_int_solot.p_insert_int_solot ( r_int_solot );
       end loop;

       pq_int_solot.p_exe_proceso (l_proceso );
       -- Cambio CC
       update solot set areasol = r_solot.areasol, codusu = r_solot.codusu
       where codsolot in ( select codsolot from int_solot where proceso = l_proceso );

     end if;
     --4.0 fin de traslados externos
   end if;

end;
/
