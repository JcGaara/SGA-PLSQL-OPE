create or replace package operacion.pkg_tpe as
  /****************************************************************************
   Nombre Package    : pkg_tpe
   Proposito         : Generar datos de Telefonía Publica de Exteriores
   REVISIONES:
   Ver  Fecha       Autor             Solicitado por    Descripcion
   ---  ----------  ----------------  ----------------  ----------------------
   1.0  06/05/2015  Jose Ruiz         Eustaquio Jibaja  
   2.0  2015-06-25  Freddy Gonzales   Eustaquio Jibaja  SD 372800
   3.0  2015-07-09  Freddy Gonzales   Hector Huaman     SD-335922
  ****************************************************************************/
  procedure generar_cod_externos(p_codinssrv  inssrv.codinssrv%type,
                                 p_tipsrv     solot.tipsrv%type,
                                 p_codsolot   solot.codsolot%type,
                                 p_codcli     solot.codcli%type,
                                 p_cuenta     number,
                                 p_opcion     number,
                                 p_pidorigen  number,
                                 p_enviar_itw number,
                                 p_resultado  in out varchar2,
                                 p_mensaje    in out varchar2,
                                 p_error      in out number);

  function es_tpe(p_tipsrv tystipsrv.tipsrv%type) return boolean;

  function get_tpe return tystipsrv.tipsrv%type;

  function get_tiptra return solot.tiptra%type;

  procedure set_vtadetptoenl(p_numslc      vtatabslcfac.numslc%type,
                             p_codsuc      vtasuccli.codsuc%type,
                             p_codequcomct vtadetptoenl.codequcom%type,
                             p_codequcome  vtadetptoenl.codequcom%type,
                             p_cant_lineas integer,
                             p_texto       varchar2);

  function get_valor(p_abreviacion opedd.abreviacion%type)
    return opedd.codigoc%type;

  function get_numpto(p_numslc vtatabslcfac.numslc%type)
    return vtadetptoenl.numpto%type;
  
  function get_grupo(p_numslc vtatabslcfac.numslc%type)
    return vtadetptoenl.grupo%type;

  function existe_comodato(p_numslc    vtadetptoenl.numslc%type,
                           p_codequcom vtadetptoenl.codequcom%type)
    return boolean;

  procedure insert_vtadetptoenl(p_vtadetptoenl vtadetptoenl%rowtype);

  function aplicar_tpe(p_tipsrv   tystipsrv.tipsrv%type,
                       p_campanha campanha.idcampanha%type) return number;
  
  function esta_habilitado return boolean;
  
  function es_campanha_tpe(p_campanha campanha.idcampanha%type) return boolean;
  
  function get_idcampanha(p_codsolot solot.codsolot%type)
    return vtatabslcfac.idcampanha%type;
  
  function get_tipsrv(p_codsolot solot.codsolot%type)
    return vtatabslcfac.tipsrv%type;

end;
/
