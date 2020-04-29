ALTER TABLE operacion.sgat_df_condicion_cab
    ADD CONSTRAINT fk_conc_cont FOREIGN KEY ( concn_idtipocondicion )
        REFERENCES operacion.sgat_df_condicion_tipo ( contn_idtipocondicion );
