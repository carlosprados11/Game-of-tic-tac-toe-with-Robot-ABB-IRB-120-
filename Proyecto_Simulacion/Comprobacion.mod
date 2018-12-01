MODULE Comprobacion


    PROC Comprueba()

        FOR i FROM 1 TO 3 DO
            ! Comprobamos si hay 3 en raya en las filas
            IF (tablero{i,1}=tablero{i,2} AND tablero{i,1}=tablero{i,3}) THEN
                ganador{juegos}:=tablero{i,1};
                ! Comprobamos si hay 3 en raya en las columnas
            ELSEIF (tablero{1,i}=tablero{2,i} AND tablero{2,i}=tablero{3,i}) THEN
                ganador{juegos}:=tablero{1,i};
            ENDIF
        ENDFOR

        ! Comprobamos si hay 3 en raya en ambas diagonales
        IF (tablero{1,1}=tablero{2,2} AND tablero{1,1}=tablero{3,3}) THEN
            ganador{juegos}:=tablero{2,2};
        ELSEIF (tablero{1,3}=tablero{2,2} AND tablero{2,2}=tablero{3,1}) THEN
            ganador{juegos}:=tablero{2,2};
        ENDIF

    ENDPROC


    PROC Ganado()

        TPErase;
        IF ganador{juegos}=1 THEN
            TPWrite "HAS GANADO. ENHORABUENA";
        ELSEIF ganador{juegos}=2 THEN
            TPWrite "HAS PERDIDO. SIGUE MEJORANDO";
        ENDIF

    ENDPROC


    PROC Ganador_Tiempo()
    
        VAR num duracion_min{2};
        VAR num duracion_seg{2};
        
        FOR i FROM 1 TO 2 DO
            
            duracion_min{i}:=Trunc(ClkRead(tiempo{i})/60);
            duracion_seg{i}:=ClkRead(tiempo{i})-60*duracion_min{i};
            
        ENDFOR
        
        ! Almaceno los datos en un fichero de texto
        Open "HOME:"\File:="Resultados.txt",resultados\Append;
        Write resultados,"";
        Write resultados, "RESULTADOS (" + CTime() + " - " + CDate() + ")";
        
        FOR i FROM 1 TO 2 DO

            Write resultados, "Partida "\Num:=i \NoNewLine;
            Write resultados, ":";
            Write resultados, "Tiempo de juego: "\Num:=duracion_min{i} \NoNewLine;
            Write resultados, "' "\Num:=duracion_seg{i} \NoNewLine;
            Write resultados, "''";
            
            IF ganador{i}=0 THEN
                Write resultados, "Empate";
                
            ELSEIF ganador{i}=1 THEN
                Write resultados, "Gano Usuario";
                
            ELSE
                Write resultados, "Gano Robot";
                
            ENDIF

        ENDFOR
        
        Close resultados;
        
        !Ahora los muestro por pantalla
        TPErase;
        TPWrite "RESULTADOS (" + CTime() + " - " + CDate() + ")";
        
        FOR i FROM 1 TO 2 DO

            TPWrite "Partida " \Num:=i;
            TPWrite "Tiempo de juego: ";
            TPWrite "Minutos: "\Num:=duracion_min{i};
            TPWrite "Segundos: "\Num:=duracion_seg{i};
        
            IF ganador{i}=0 THEN
                TPWrite "Empate";

            ELSEIF ganador{i}=1 THEN
                TPWrite "Gano Usuario";

            ELSE
                TPWrite "Gano Robot";

            ENDIF

        ENDFOR
        
        WaitTime 10;
        
        ! Rutina de errores del fichero
    ERROR
        IF ERRNO=ERR_FILEACC THEN
            TPErase;
            TPWrite "Error al acceder al archivo de escritura Resultados.txt";
            EXIT;
            
        ELSEIF ERRNO=ERR_FILEOPEN THEN
            TPErase;
            TPWrite "No se puede abrir al archivo Resultados.txt";
            EXIT;
        
        ELSEIF ERRNO=ERR_FILNOTFND THEN
            TPErase;
            TPWrite "Archivo Resultados.txt no encontrado";
            EXIT;
            
        ENDIF    

    ENDPROC

    
ENDMODULE