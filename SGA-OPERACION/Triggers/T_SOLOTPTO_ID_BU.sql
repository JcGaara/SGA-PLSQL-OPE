CREATE OR REPLACE TRIGGER OPERACION.t_solotpto_id_bu
  BEFORE UPDATE ON solotpto_id
  FOR EACH ROW

/*declare
  l_count  number;
  l_cuenta number;
  l_user   varchar2(30);
  l_tipsrv char(4);
  l_tiptrs number(2);*/

/******************************************************************************
CAMBIOS

Fecha        Autor           Descripcion
----------  ---------------  ------------------------
26/01/2007 Gustavo Ormeo  Cambio de grupo detinatario en correo
   1.0    06/10/2010                      REQ.139588 Cambio de Marca

******************************************************************************/
BEGIN
  IF UPDATING('CODCON') THEN
   /* l_user := user;

    begin
      select distinct s.tipsrv,tip.tiptrs
        into l_tipsrv,l_tiptrs
        from solot s,tiptrabajo tip
       where s.tiptra=tip.tiptra
       and s.codsolot = :old.codsolot
       and ;
    exception
      when others then
        l_tipsrv := '';
        l_tiptrs := '';
    end;

    select count(*)
      into l_cuenta
      from opedd
     where tipopedd = 216
       and codigoc = l_tipsrv;

    select count(*)
      into l_count
      from opedd
     where tipopedd = 215
       and descripcion = l_user;

    IF (l_count > 0 and l_cuenta > 0) THEN*/

      INSERT INTO OPERACION.solotpto_id_log
        (codsolot, usuario_mod, fec_mod, codcon)
      VALUES
        (:OLD.codsolot, user, sysdate, nvl(:old.codcon, null));
/*
    ELSE
      p_envia_correo_c_attach('Programación de Intalaciones',
                              'DL-PE-ITSoportealNegocio', --1.0
                              'El usuario: ' || l_user ||
                              ' está intentando cambiar la Contrata Asignada a la SOT ' ||
                              :old.codsolot || ' punto ' || :old.punto || '.',
                              null,
                              'SGA-Programacion-Instalaciones'); --1.0
      RAISE_APPLICATION_ERROR(-20500,
                              'Usted no tiene privilegios para cambiar la Asignación de Contrata');

    END IF;*/
  END IF;
END;
/



