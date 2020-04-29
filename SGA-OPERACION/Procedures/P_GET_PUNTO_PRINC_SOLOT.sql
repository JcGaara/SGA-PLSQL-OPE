CREATE OR REPLACE PROCEDURE OPERACION.P_GET_PUNTO_PRINC_SOLOT (
   a_codsolot in number,
   a_punto out number,
   a_punto_ori out number,
   a_punto_des out number,
   a_tipsrv in char default null --2.0
)
IS
/******************************************************************************
   NAME:       OPERACION.P_GET_PUNTO_PRINC_SOLOT
   PURPOSE:    Retorna el punto de la solicitud que corresponde al servicio principal de la solicitud.En general para el primer punto que tenga un PID principal
               Sino el primer punto de la solicitud, Si la ISP es de tipo enlace y los puntos Origen y Destino se encuentran dentro de la misma SOT devuelve los valores en : a_punto_ori, a_punto_des.
               En el caso de PLS debe obtener el punto del enlace

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        30/07/2009  Hector Huaman M. REQ.98231.Tiene prioridad los servicos de acceso.
   2.0        04/02/2010  Antonio Lagos    REQ 106908 Bundle DTH+CDMA,busqueda de punto principal por tipo de servicio
******************************************************************************/



l_punto solotpto.punto%type;
l_tip inssrv.tipinssrv%type;
l_codinssrv inssrv.codinssrv%type;
l_codinssrv_ori inssrv.codinssrv%type;
l_codinssrv_des inssrv.codinssrv%type;
l_des solotpto.punto%type;
l_ori solotpto.punto%type;

-- Priemro busca en los enlaces
cursor cur_princ is
   select sp.punto, i.tipinssrv, i.codinssrv, i.codinssrv_ori, i.codinssrv_des  from
   solotpto sp,
   insprd p,
   inssrv i
   where sp.codsolot = a_codsolot
   and sp.codinssrv = i.codinssrv
   and sp.pid = p.pid
   and p.flgprinc = 1
   and (i.tipsrv = a_tipsrv or a_tipsrv is null) --2.0
   order by--<1.0
      --i.tipinssrv desc;
      i.tipinssrv; --1.0>

cursor cur_any is
   select sp.punto, i.tipinssrv, i.codinssrv, i.codinssrv_ori, i.codinssrv_des from
   solotpto sp,
   inssrv i
   where sp.codsolot = a_codsolot
   and sp.codinssrv = i.codinssrv
   order by
      i.tipinssrv desc, sp.punto ;

cursor cur_orides is
   select sp.punto   from
   solotpto sp,
   insprd p
   where sp.codsolot = a_codsolot
   and sp.codinssrv = l_codinssrv
   and sp.pid = p.pid (+)
--   and nvl(p.flgprinc,0) = 1
   order by
      nvl(p.flgprinc,0), sp.punto;

cursor cur_any2 is
   select sp.punto from
   solotpto sp
   where sp.codsolot = a_codsolot
   order by
      sp.punto ;

BEGIN

   for c1 in cur_princ loop
      l_punto := c1.punto ;
      l_tip := c1.tipinssrv;
      l_codinssrv_ori := c1.codinssrv_ori;
      l_codinssrv_des := c1.codinssrv_des;
      exit;
   end loop;

   if l_punto is null then
      for c1 in cur_any loop
         l_punto := c1.punto ;
         l_tip := c1.tipinssrv;
         l_codinssrv_ori := c1.codinssrv_ori;
         l_codinssrv_des := c1.codinssrv_des;
         exit;
      end loop;
   end if;

   if l_punto is not null then
      -- si es tipo enlace se busca dentro de la SOT si los acceso estan
      -- dentro del Detalle
      if l_tip = 2 then

         l_codinssrv := l_codinssrv_ori;
         for c1 in cur_orides loop
            l_ori := c1.punto ;
            exit;
         end loop;

         l_codinssrv := l_codinssrv_des;
         for c1 in cur_orides loop
            l_des := c1.punto ;
            exit;
         end loop;

         a_punto := l_punto;
         a_punto_ori := l_ori;
         a_punto_des := l_des;

      else
         a_punto := l_punto;
         a_punto_ori := l_ori;
         a_punto_des := l_des;
      end if;

      a_punto := l_punto;
      a_punto_ori := l_ori;
      a_punto_des := l_des;

   end if;

   -- Si el detalle no esta asociado a ninguna IS
   if l_punto is null then
      for c1 in cur_any2 loop
         l_punto := c1.punto ;
         exit;
      end loop;
      a_punto := l_punto;
   end if;


END;
/


