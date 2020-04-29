CREATE OR REPLACE PROCEDURE OPERACION.p_corteservicios( a_idtareawf in number,
  							               a_idwf in number,
							                 a_tarea in number,
							                 a_tareadef in number
							               )
  IS
  l_codsolot solot.codsolot%type;
  tipoSOT solot.tiptra%type;
  motivoSOT solot.codmotot%type;
  l_cierrok number;
  l_dept plannumeracion.desctrading%type;

  code VARCHAR2(2); -- CÒDIGO EN DURO???

  CURSOR cur_servs IS -- obtengo todos los servicios para la SOT generada
  select n.numero, i.codinssrv,i.codubi , pq_corteservicio.f_verificanumero(n.numero) tipolinea
  from solotpto s, inssrv i, numtel n--, plannumeracion p
  where s.codsolot = l_codsolot and
      s.codinssrv = i.codinssrv and
      i.codinssrv = n.codinssrv; /*and
      i.codinssrv = 522538;*/ -- and
      --p.estadoplan in (2,9) and
      --n.numero between p.rangoinicio and p.rangofin;


  BEGIN
       select codsolot -- la SOT correspondiente al WF
       into l_codsolot
       from wf
       where idwf = a_idwf;

       select tiptra , codmotot
       into tipoSOT, motivoSOT
       from solot
       where codsolot = l_codsolot;

      ----por borrar
/*      tipoSOT := 3;
      motivoSOT := 891;*/


        code := '12';
        l_cierrok := 0;

       for r_servs in cur_servs loop
       begin
        		   select upper(p.desctrading)
               into l_dept
               from plannumeracion p
               where p.estadoplan in (2,9) and
                     r_servs.numero between p.rangoinicio and p.rangofin;


                if ((r_servs.tipolinea = 1 ) and (l_dept like '%LIMA%') ) then
                   begin
                        OPERACION.PROC_INTERFAZ_SGA_MMP(r_servs.numero, tipoSOT, motivoSOT, code, a_idwf);
                   end;
                else
                    begin
                         l_cierrok := 1;
                    end;
                end if;

          /*  tipoSOT := 4;*/
          /*  motivoSOT := 9;*/


       end;
       end loop;

       commit;
  END;
/


