CREATE OR REPLACE FUNCTION OPERACION.F_RETORNA_ESTADO_BLOQUEO(p_idtipobloqueo in varchar2,p_codsolot in number,p_punto in number,p_codinssrv in number,p_entrada in number )
RETURN NUMBER
IS
/********************************************************************************
     NOMBRE: OPERACION.F_RETORNA_ESTADO_BLOQUEO

     Creacion
     Ver     Fecha          Autor             Descripcion
    ------  ----------  ----------       --------------------
     1.0     26/06/2009  Hector Huaman  M   REQ-96260: se considera las tablas de configuracion de NCOS
     2.0     05/03/2010  Hector Huaman  M   REQ-94683: Se modifica funcion para que tome el ncos_new y ncos_old de la tabla inssrv.
 ********************************************************************************/
v_ncos_new solotpto.ncos_new%type;
v_retorno number;
v_cantidad number;
v_codsrv tystabsrv.codsrv%type;

BEGIN
--<1.0
      select  codsrvnue into v_codsrv from solotpto where codsolot=p_codsolot and punto=p_punto ;
--1.0>
       if p_entrada = 0 then
          select ncos into v_ncos_new from inssrv where codinssrv = p_codinssrv;
       else
       --<2.0
          /*select ncos_new into v_ncos_new from solotpto where codsolot = p_codsolot and punto = p_punto;*/
          begin
          select ncos_new
            into v_ncos_new
            from inssrv
           where codinssrv = p_codinssrv;
          exception
          when others then
          v_ncos_new:=null;
          end;
          if v_ncos_new is null then
             begin
             select n.codigo_ext into v_ncos_new
              from ncosxdepartamento n, inssrv i, vtatabdst v
             where n.idncos = 0
               and i.codubi = v.codubi
               and i.codinssrv = p_codinssrv
               and v.codest = n.codest;
             exception
             when others then
             v_ncos_new:='UNREST';
             end;
          end if;
       --2.0>
       end if ;

       v_retorno := 0;

       IF v_ncos_new is NULL OR v_ncos_new = '' THEN
           v_retorno := 0;
       ELSE
       --<1.0
           --v_ncos_new := '%'||v_ncos_new||'%';

             select   INSTR(c.IDTIPOBLOQUEO,p_idtipobloqueo,1,1) INTO v_cantidad
              from configuracion_itw   c,
                 configxproceso_itw  p,
                 ncosxdepartamento   n,
                 configxservicio_itw s,
                 solotpto            t,
                 v_ubicaciones       v
             where c.idconfigitw = p.idconfigitw
              and p.proceso = 19
              and c.idconfigitw = s.idconfigitw
              and c.tipo='B'
              and s.codsrv =v_codsrv
              and s.codsrv=t.codsrvnue
              and c.idncos = n.idncos
              and c.idtipobloqueo= p_idtipobloqueo
              and t.codubi = v.codubi
              and t.codsolot =p_codsolot
              and n.codigo_ext=v_ncos_new
              and v.codest = trim(n.codest);
/*
           SELECT INSTR(IDTIPOBLOQUEO,p_idtipobloqueo,1,1) INTO v_cantidad
            FROM configuracion_itw where codigo_ext like v_ncos_new
           and tipo='B';*/
          --1.0>
           IF v_cantidad > 0 THEN
              v_retorno := 1;
           END IF;
       END IF;

       return v_retorno;
END;
/


