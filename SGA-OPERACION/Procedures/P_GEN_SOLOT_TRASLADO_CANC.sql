CREATE OR REPLACE PROCEDURE OPERACION.p_gen_solot_traslado_canc (
   a_codsolot in number
) is
/**********************************************************************
Genera las SOT de traslado en base a una SOT
**********************************************************************/
Cursor cur_pto is
   select distinct codinssrv, codinssrv_tra from solotpto where codsolot = a_codsolot
   and codinssrv_tra is not null;

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

      l_proceso := pq_int_solot.f_get_id_proceso;

      r_int_solot.proceso := l_proceso;
      r_int_solot.codcli := r_solot.codcli;
      r_int_solot.tiptra := 17;
      r_int_solot.estsol := 11;
      r_int_solot.numslc := r_solot.numslc;
      --r_int_solot.recosi := r_solot.recosi;
      --r_int_solot.motot := r_solot.motot;
      r_int_solot.tipsrv := r_solot.tipsrv;
      r_int_solot.feccom := sysdate + 7;


      for r_pto in cur_pto loop
         begin
            select numero into l_num from inssrv where codinssrv = r_pto.codinssrv;
            l_obs := 'SOT generada por la activación de '||l_num;
            l_obs := l_obs||chr(13)||'Proyecto '|| r_solot.numslc;
            l_obs := l_obs||', SOT '|| r_solot.codsolot;
         exception
            when others then
               l_obs := null;
         end;

         r_int_solot.observacion := l_obs;
         r_int_solot.codinssrv := r_pto.codinssrv_tra;

         pq_int_solot.p_insert_int_solot ( r_int_solot );
      end loop;

      pq_int_solot.p_exe_proceso (l_proceso );

   end if;

end;
/


