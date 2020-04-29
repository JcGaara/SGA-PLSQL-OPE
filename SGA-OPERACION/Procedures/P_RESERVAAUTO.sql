CREATE OR REPLACE PROCEDURE OPERACION.P_RESERVAAUTO(v_reserva VARCHAR) is
/*
Fecha Creación: 19/09/2007
Creado por: Juan Carlos Lara
Descripcion: Permite cargar los proyectos que generaran reservas automaticas para el siguiente dia
*/
n_pos number;
n_proy number;
n_cont number;
n_len number;
v_aux varchar(4000);
begin

     n_pos := 1;
     v_aux := v_reserva;

     while  (n_pos > 0) loop
          n_len := length(v_aux);
          n_pos := nvl(Instr(v_aux, ',', 1, 1),-1);
          if n_pos > 0 then
              n_proy := to_number(substr(v_aux,1,n_pos-1));
              
              select count(*) into n_cont 
              from operacion.reserva_aut 
              where numslc = n_proy;
              
              if n_cont = 0 then 

                      insert into operacion.reserva_aut
                      (numslc, fec_creacion, usu_creacion, fec_ejecucion, estado)
                      values
                      (n_proy, sysdate, user,null,0);
              end if;

              v_aux := substr(v_aux,n_pos+1,n_len-n_pos);

          end if;
          if n_pos = 0 then
              n_proy := to_number(substr(v_aux,1,n_len));

              insert into operacion.reserva_aut
              (numslc, fec_creacion, usu_creacion, fec_ejecucion, estado)
              values
              (n_proy, sysdate, user,null,0);

              v_aux := '';

          end if;
          commit;
     end loop;
     commit;
end P_RESERVAAUTO;
/


