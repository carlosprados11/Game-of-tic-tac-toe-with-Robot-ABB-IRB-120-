MODULE M_Menu

    !local PERS tooldata Pinza_Neumatica:=[TRUE,[[0,0,40],[1,0,0,0]],[0.3,[0,0,1],[1,0,0,0],0,0,0]];
    
    FUNC robtarget Menu(num tipo)

        VAR num v1;
        VAR num v2;
        VAR robtarget deja;
        
        ! Pieza roja
        IF tipo=1 THEN   

            TPErase;
            TPReadFK v1,"Posición a colocar la pieza:","Arriba","Medio","Abajo","","";
            TPReadFK v2,"","Izquierda","Medio","Derecha","","";

            WHILE (tablero{v1,v2}=1 OR tablero{v1,v2}=2) DO
                ! Lugar ocupado

                TPWrite "La posicion seleccionada está ocupada";
                TPWrite "Prueba con otra";

                TPReadFK v1,"Posición a colocar la pieza:","Arriba","Medio","Abajo","","";
                TPReadFK v2,"","Izquierda","Medio","Derecha","","";

            ENDWHILE

        ! Pieza verde (mediante generación de numeros aleatorios)
        ELSE
            
            v1:=random();
            ! Devuelve posicion a dejar la pieza verde  
            v2:=random();
            WHILE (tablero{v1,v2}=1 OR tablero{v1,v2}=2) DO
                ! Pieza ocupada, genero nuevo numero aleatorio
                v1:=random();
                v2:=random();
            ENDWHILE

        ENDIF

        ! Define posiciones donde dejar la pieza
        deja:=pos_tab{v1,v2};

        ! Incluye la pieza a dejar en la matriz de piezas situadas
        tablero{v1,v2}:=tipo;
        
        ! Ultima posición que hemos elegido para poder borrarla si es necesario
        ultima_fila:=v1;
        ultima_colu:=v2;
        
        RETURN deja;
        ! Devuelve posicion donde dejar la pieza

    ENDFUNC

ENDMODULE