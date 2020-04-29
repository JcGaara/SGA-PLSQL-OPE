CREATE OR REPLACE PROCEDURE OPERACION.P_GET_ESTADO_SOT(a_codsolot  in number,
                                                       a_tipestsol out number,
                                                       a_estsol    out string) IS

  /*****************************************************************************
    Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------  ------------------------------------

    1.0       28/03/2012  Alfonso Pérez    Procedimiento que consulta Consulta el
                                           tipo de Estado y Estado Agendamiento
    2.0       26/04/2012  Alex Alamo       Modificacion de la logica
    3.0       04/02/2013  Samuel Inga      Modificacion para mostrar el estado 
                                           detallado de la SOT.
  ******************************************************************************/
  n_estage    number(5);
  s_estagenda varchar2(100);
  n_idagenda  number; ---2.0
  s_estadosot varchar2(100); --3.0

BEGIN

  s_estagenda := '';

  begin

    select c.tipestsol,
          --ini 3.0
           c.descripcion,
           b.descripcion
      into a_tipestsol,
           a_estsol,
           s_estadosot
          --fin 3.0
          -- n_estage --ini 2.0
      from solot a,
           estsol b,
           tipestsol c
           /*agendamiento d*/ --ini 2.0
     where a.estsol = b.estsol
       and b.tipestsol = c.tipestsol
       and a.codsolot = a_codsolot;
       
  -- ini 2.0
        select max(idagenda) into n_idagenda 
            from agendamiento 
        where codsolot = a_codsolot;
         
       /*if a_tipestsol = 6 and not n_estage is null then  */               
      if a_tipestsol = 6 and not n_idagenda is null THEN 
      --fin 2.0
     
        select estage into n_estage
           from agendamiento
        where idagenda=n_idagenda;
  

        select trim(descripcion)
          into s_estagenda
          from estagenda
         where estage = n_estage;

         a_estsol := a_estsol || ' - ' || s_estadosot || ' - ' || s_estagenda; -- 3.0

      else
         a_estsol := a_estsol || ' - ' || s_estadosot;           
      end if;

  exception
    when no_data_found then
      a_tipestsol := -1;
      a_estsol    := 'SOT no existe';
  end;  

END;
/