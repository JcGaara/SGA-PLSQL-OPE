create or replace package atccorp.PQ_CUADRILLA is

/***********************************************************************************************
    NOMBRE:     ATCCORP.PQ_CUADRILLA
    PROPOSITO:  Realizar toda la funcionalidad de Agendamiento de cuadrilla de Perú
    PROGRAMADO EN JOB:  NO

    REVISIONES:
    Version      Fecha        Autor             Solicitado Por        Descripcion
    ---------  ----------  -----------------    --------------        ------------------------
    1.0        25/10/2011  Alfonso Pérez        Elver Ramirez         REQ-159092: Se crea el paquete pq_cuadrilla
  **********************************************************************************************/


procedure p_actualizacuadrilla(an_codincidence in number,
                               a_fecccom       in varchar);

procedure p_agendacuadrilla(a_fecccom       in varchar2,
                            an_tiptra       in number,
                            an_codincidence in number,
                            as_codcli       in varchar2,
                            an_resultado    out number);
                                    
procedure p_cancelaragenda (an_codincidence in number,
                            an_res          out number) ;

procedure p_envia_correocancela(an_codincidence number,
                                o_resultado     out number,
                                o_mensaje       out varchar2);                            

procedure p_envia_correoreagenda(an_codincidence number,
                                 o_resultado      out number,
                                 o_mensaje        out varchar2);        

procedure p_reagendacuadrilla(a_fecccom       in varchar2,
                              an_codincidence in number,
                              an_tiptra       in number,
                              as_observacion  in varchar2,
                              an_res          out number );
                              
function f_verificahora(a_fecccom   in varchar2,
                        an_tiptra   in number) return varchar2;      

function f_obtiene_cuadrilla(as_codcli in varchar2, an_tiptra in number) return number ;                                                                                                        

                                                                
end PQ_CUADRILLA;
/
