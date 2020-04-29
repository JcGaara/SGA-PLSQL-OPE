CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_LICITACION IS
  /*******************************************************************************************************
    NOMBRE:       OPERACION.PQ_LICITACION
    PROPOSITO:    Paquete de objetos necesarios para la Conexion del SGA - BSCS
    REVISIONES:
    Version    Fecha       Autor            Solicitado por    Descripcion
    ---------  ----------  ---------------  --------------    -----------------------------------------
     1.0       09/08/2013  Edilberto Astulle
     2.0       14/03/2017  Felipe Maguiña   PROY-19296        Visualización de Solución a la Medida
     3.0       14/03/2017  Conrad Agüero   PROY-19296         Visualización de Solución a la Medida
  *******************************************************************************************************/
procedure p_crear_licitacion(an_tipo in number,
                           av_proceso in varchar2 default null,
                           av_contrato in varchar2 default null)
is
n_idlicitacion number;
begin
  SELECT operacion.SQ_SEQLICITACION.nextval into n_idlicitacion from dual;
  insert into operacion.licitacion(idlicitacion,tiplic,proceso,contrato)
  values  (n_idlicitacion,an_tipo,av_proceso,av_contrato);
end;

procedure p_cambio_est_licitacion(an_idlicitacion in number,
                           an_estlic in number,
                           av_observacion in varchar2 default null)
is
n_idseq number;
begin
  if av_observacion is null or av_observacion = '' then
    raise_application_error(-20500,'Debe ingresar un comentario para poder cambiar de estado.');
  end if;
  update operacion.licitacion set estlic = an_estlic
  where idlicitacion = an_idlicitacion;
  SELECT operacion.SQ_SEQESTLIC.nextval into n_idseq from dual;
  insert into operacion.liccamestado(idseq,idlicitacion,estlic,observacion)
  values  (n_idseq, an_idlicitacion, an_estlic, av_observacion);

end;

procedure p_asociar_sot_licitacion(an_idlicitacion in number,
                           an_codsolot in number)
is
n_idseq number;
begin
  if an_idlicitacion is null or an_idlicitacion = 0 then
    raise_application_error(-20500,'Debe ingresar un codigo de Licitacion.');
  end if;
  insert into operacion.solotxlic(idlicitacion,codsolot)
  values  (an_idlicitacion,an_codsolot);
end;

procedure p_desasociar_sot_licitacion(an_idlicitacion in number,
                           an_codsolot in number)
is
n_idseq number;
begin
  if an_idlicitacion is null or an_idlicitacion = 0 then
    raise_application_error(-20500,'Debe ingresar un codigo de Licitacion.');
  end if;
  delete operacion.solotxlic where idlicitacion= an_idlicitacion and codsolot=an_codsolot;
end;
-- Ini 2.0
PROCEDURE SGASU_ACT_FEC_SOT(K_CODSOLOT     operacion.solot.codsolot%TYPE,
                              K_IDLICITACION operacion.licitacion.idlicitacion%TYPE,
                              K_RESULTADO    OUT NUMBER,
                              K_MENSAJE      OUT VARCHAR2) IS
    V_FEC_ENTREGA DATE;
  BEGIN
    K_RESULTADO := 0;
    K_MENSAJE   := 'OK';
    --obtener fecha de entrega de proyectos
    SELECT lic.fefircontra + lic.plazo
      INTO V_FEC_ENTREGA
      FROM operacion.licitacion lic
     WHERE lic.idlicitacion = K_IDLICITACION;

    --actualizar fecha de compromiso
    UPDATE operacion.solot s
       SET s.feccom = V_FEC_ENTREGA
     WHERE s.codsolot = K_CODSOLOT;

  EXCEPTION
    WHEN OTHERS THEN
      K_RESULTADO := -1;
      K_MENSAJE   := 'Error en SGASU_ACT_FEC_SOT --> Nro:' ||
                     to_char(SQLCODE) || ' Msg:' || SQLERRM;
  END;

   PROCEDURE SGASI_ASOC_LICITACION(K_CODCLI         marketing.vtatabcli.codcli%TYPE,
                                  k_nro_licitacion SALES.vtatabslcfac.nro_licitacion%type,
                                  k_idlicitacion   operacion.licitacion.idlicitacion%type,
                                  K_RESULTADO      OUT NUMBER,
                                  K_MENSAJE        OUT VARCHAR2) is

    V_IPAPLICACION VARCHAR2(100);
    V_NOM_PC       VARCHAR2(30);
    V_MAX_SEQ      operacion.licitacionxsot.idseq%TYPE;
    K_COUNT     NUMBER;
  -- Ini 3.0
  -- Cursor para obtener las SOTs  
    cursor cur_lic is
    select   s.codsolot             
        from solot s, vtatabslcfac v
       where s.numslc = v.numslc
         and s.codcli = v.codcli
         and v.nro_licitacion = k_nro_licitacion
         and v.codcli = K_CODCLI
         and NOT EXISTS (select 1 from operacion.licitacionxsot l WHERE l.codsolot = s.codsolot )
         and v.nro_licitacion is not null;
  -- Fin 3.0 
  BEGIN
    null;
    K_RESULTADO := 0;
    K_MENSAJE   := 'OK';


    V_IPAPLICACION := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
    V_NOM_PC       := SYS_CONTEXT('USERENV', 'HOST', 30);
    SELECT MAX(idseq) INTO V_MAX_SEQ FROM operacion.licitacionxsot;



   select count(1) into K_COUNT
        from solot s, vtatabslcfac v
       where s.numslc = v.numslc
         and s.codcli = v.codcli
         and v.nro_licitacion = k_nro_licitacion
         and v.codcli = K_CODCLI
         and NOT EXISTS (select 1 from operacion.licitacionxsot l WHERE l.codsolot = s.codsolot )
         and v.nro_licitacion is not null;

   IF  K_COUNT = 0 THEN
      K_RESULTADO := -1;
      K_MENSAJE   := 'NO HAY SOT ASOCIADA A ESTA LICITACION O YA ESTA ASOCIADA';
   ELSE
  -- Ini 3.0
   for C in cur_lic loop
     INSERT INTO operacion.licitacionxsot
      (idseq, codsolot, idlicitacion)
      values ((SELECT MAX(idseq) + 1 FROM operacion.licitacionxsot), c.codsolot, k_idlicitacion);
   end loop;   
  -- Fin 3.0   
      
   END IF;


  EXCEPTION
    WHEN OTHERS THEN
      K_RESULTADO := -1;
      K_MENSAJE   := 'Error en SGASI_ASOC_LICITACION --> Nro:' ||
                     to_char(SQLCODE) || ' Msg:' || SQLERRM;
  END;

  PROCEDURE SGASU_ACT_INSSRV(K_CODINSSRV operacion.inssrv.codinssrv%TYPE,
                             K_RESULTADO OUT NUMBER,
                             K_MENSAJE   OUT VARCHAR2) IS
    V_FLGSOL      NUMBER;
    V_FLGSOL_TRAS NUMBER;

  BEGIN
    K_RESULTADO   := 0;
    K_MENSAJE     := 'OK';
    V_FLGSOL      := 0;
    V_FLGSOL_TRAS := 0;

    --Nuevo
    BEGIN
      SELECT flgsolmedida
        INTO V_FLGSOL
        FROM efptoequ
       WHERE codef in
             (SELECT codef
                FROM ef
               WHERE numslc in
                     (SELECT numslc FROM inssrv WHERE codinssrv = K_CODINSSRV))
         AND flgsolmedida = 1
         AND rownum = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_FLGSOL := 0;
    END;
    --Traslado
    BEGIN
      SELECT flgsolmedida
        INTO V_FLGSOL_TRAS
        FROM inssrv
       WHERE codinssrv =
             (select CODINSSRV_TRAS
                from vtadetptoenl
               where rownum = 1
                 and numslc =
                     (select numslc from inssrv where codinssrv = K_CODINSSRV));
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_FLGSOL_TRAS := 0;
    END;

    IF (V_FLGSOL = 1) OR (V_FLGSOL_TRAS = 1) THEN
      UPDATE operacion.inssrv i
         SET i.flgsolmedida = 1 --modif campo
       WHERE i.codinssrv = K_CODINSSRV;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      K_RESULTADO := -1;
      K_MENSAJE   := 'Error en SGASU_ACT_INSSRV --> Nro:' ||
                     to_char(SQLCODE) || ' Msg:' || SQLERRM;
  END;

PROCEDURE SGASS_VAL_GESTION(  K_BACKLOG   NUMBER,
                              K_RESULTADO OUT NUMBER,
                              K_MENSAJE   OUT VARCHAR2) IS
  BEGIN


    IF K_BACKLOG = 1 THEN
         K_RESULTADO := 0;
         K_MENSAJE   := 'OK';
    ELSE
      K_RESULTADO := -1;
      K_MENSAJE   := 'Debe seleccionar la Lista de Gestion de Gobierno';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      K_RESULTADO := -1;
      K_MENSAJE   := 'Error en SGASS_VAL_GESTION --> Nro:' ||
                     to_char(SQLCODE) || ' Msg:' || SQLERRM;
  END;



  FUNCTION SGAFUN_PROVEEDOR(k_num ef.numslc%TYPE, k_tip number)
    RETURN VARCHAR2 IS
    v_i          number;
    v_provee     varchar2(200);
    v_provee_tot varchar2(2000);
    cursor c_prov_ins is
      SELECT codprovinstalacion
        FROM operacion.EFPTOEQU
       WHERE codef in (SELECT codef FROM ef WHERE numslc = k_num);

    cursor c_prov_man is
      SELECT CODPROVMANTENIM
        FROM operacion.EFPTOEQU
       WHERE codef in (SELECT codef FROM ef WHERE numslc = k_num);
  BEGIN
    v_i := 1;
    IF k_tip = 1 THEN
      FOR fila IN c_prov_ins LOOP
        IF v_i = 1 THEN
          select nombre
            into v_provee
            from contrata
           where codcon = fila.codprovinstalacion;
          v_provee_tot := v_provee;
        ELSE
          select nombre
            into v_provee
            from contrata
           where codcon = fila.codprovinstalacion;
          v_provee_tot := v_provee_tot || ' | ' || v_provee;
        END IF;
        v_i := 1 + v_i;
      END LOOP;
      RETURN v_provee_tot;
    ELSE
      FOR fila IN c_prov_man LOOP
        IF v_i = 1 THEN
          select nombre
            into v_provee
            from contrata
           where codcon = fila.CODPROVMANTENIM;
          v_provee_tot := v_provee;
        ELSE
          select nombre
            into v_provee
            from contrata
           where codcon = fila.CODPROVMANTENIM;
          v_provee_tot := v_provee_tot || ' | ' || v_provee;
        END IF;
        v_i := 1 + v_i;
      END LOOP;
      RETURN v_provee_tot;
    END IF;

  END;
-- Fin 2.0

END PQ_LICITACION;
/