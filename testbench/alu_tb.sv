// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 1
//
// Testbench: ALU
//
// Descripción:
// Verifica el funcionamiento de la ALU para las operaciones
// aritméticas y lógicas definidas en la especificación.
//
// Autor / Verification Engineer:
// Nombre: John Hibbert Bonilla
// Fecha de primera versión: 12/10/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripción
// ------------------------------------------------------------
// 12/10/2026  | John Hibbert Bonilla | Primera versión
// 20/10/2026  | John Hibbert Bonilla | Segunda versión
// ============================================================

module alu_tb;

    // Señales del testbench
    logic [31:0] A;
    logic [31:0] B;
    logic [3:0]  ALUControl;

    logic [31:0] Result;
    logic        Zero;
    // Contadores de resultados
    integer pass_count = 0; // Contador de pruebas exitosas
    integer fail_count = 0; // Contador de pruebas fallidas
    // Instancia del módulo bajo prueba
    alu dut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero)
    );
    //$display("ALU-01 | ADD | FAIL | A=%0d, B=%0d, Result=%0d, Zero=%b | Esperado: Result=8, Zero=0"
    //Esta es la estructura que se toma para las pruebas puntuales que se estan realizando en la alu

    initial begin

        // ====================================================
        // TEST 1 - ADD
        // ====================================================
        A = 5;
        B = 3;
        ALUControl = 4'b0000;

        #10;

        
        if ((Result === 32'd8) && (Zero === 1'b0)) begin
            $display("ALU-01 | ADD | PASS | A=%0d, B=%0d, Result=%0d, Zero=%b",
                     A, B, Result, Zero);
            pass_count = pass_count + 1;
        end
        else begin
            $display("ALU-01 | ADD | FAIL | A=%0d, B=%0d, Result=%0d, Zero=%b | Esperado: Result=8, Zero=0",
                     A, B, Result, Zero);
            fail_count = fail_count + 1;
        end


        // ====================================================
        // TEST 2 - SUB
        // ====================================================
        
        A = 5;
        B = 3;
        ALUControl = 4'b0001;

        #10;

        if ((Result === 32'd2) && (Zero === 1'b0)) begin
            $display("ALU-02 | SUB | PASS | A=%0d, B=%0d, Result=%0d, Zero=%b",
                     A, B, Result, Zero);
            pass_count = pass_count + 1;
        end
        else begin
            $display("ALU-02 | SUB | FAIL | A=%0d, B=%0d, Result=%0d, Zero=%b", 
                     A, B, Result, Zero);
            fail_count = fail_count + 1;
        end


        // ====================================================
        // TEST 3 - AND
        // ====================================================
        
        A = 5;
        B = 3;
        ALUControl = 4'b0010;

        #10;

        if ((Result === 32'd1) && (Zero === 1'b0)) begin
            $display("ALU-03 | AND | PASS | A=%0d, B=%0d, Result=%0d, Zero=%b",
                     A, B, Result, Zero);
            pass_count = pass_count + 1;
        end
        else begin
            $display("ALU-03 | AND | FAIL | A=%0d, B=%0d, Result=%0d, Zero=%b",
                     A, B, Result, Zero);
            fail_count = fail_count + 1;
        end


        // ====================================================
        // TEST 4 - OR
        // ====================================================
       
        A = 5;
        B = 3;
        ALUControl = 4'b0011;

        #10;

        if ((Result === 32'd7) && (Zero === 1'b0)) begin
            $display("ALU-04 | OR | PASS | A=%0d, B=%0d, Result=%0d, Zero=%b",
                     A, B, Result, Zero);
            pass_count = pass_count + 1;
        end
        else begin
            $display("ALU-04 | OR | FAIL | A=%0d, B=%0d, Result=%0d, Zero=%b",
                     A, B, Result, Zero);
            fail_count = fail_count + 1;
        end


        // ====================================================
        // TEST 5 - RESULTADO CERO
        // ====================================================
        A = 5;
        B = 5;
        ALUControl = 4'b0001;

        #10;

        if ((Result === 32'd0) && (Zero === 1'b1)) begin
            $display("ALU-05 | ZERO | PASS | A=%0d, B=%0d, Result=%0d, Zero=%b",
                     A, B, Result, Zero);
            pass_count = pass_count + 1;
        end
        else begin
            $display("ALU-05 | ZERO | FAIL | A=%0d, B=%0d, Result=%0d, Zero=%b | Esperado: Result=0, Zero=1",
                     A, B, Result, Zero);
            fail_count = fail_count + 1;
        end


        // ====================================================
        // TEST 6 - RESULTADO NEGATIVO
        // ====================================================
        A = 3;
        B = 5;
        ALUControl = 4'b0001;
        //El resultado se espera en negativo y la ALU trabaja con complemento a 2 de 32 bits por lo que el resultado estará en hexadecimal
        #10;

        if ((Result === 32'hFFFFFFFE) && (Zero === 1'b0)) begin
            $display("ALU-06 | NEGATIVE | PASS | A=%0d, B=%0d, Result=%h, Zero=%b",
                     A, B, Result, Zero);
            pass_count = pass_count + 1;
        end
        else begin
            $display("ALU-06 | NEGATIVE | FAIL | A=%0d, B=%0d, Result=%h, Zero=%b | Esperado: Result=FFFFFFFE, Zero=0",
                     A, B, Result, Zero);
            fail_count = fail_count + 1;
        end


        // ====================================================
        // TEST 7 - PRUEBA FALLIDA 
        // ====================================================
        A = 5;
        B = 3;
        ALUControl = 4'b0000; // Utilizamos ADD como fail aunque se puede utilizar cualquier otra operacion

        #10;

        if (Result === 32'd9) begin
            $display("ALU-07 | ADD | PASS | A=%0d, B=%0d, Result=%0d",
                     A, B, Result);
            pass_count = pass_count + 1;
        end
        else begin
            $display("ALU-07 | ADD | FAIL | A=%0d, B=%0d, Result=%0d | Esperado: Result=9",
                     A, B, Result);
            fail_count = fail_count + 1;
        end



        // ====================================================
        // RESUMEN FINAL
        // ====================================================
        $display("--------------------------------");
        $display("Resumen de pruebas de la ALU");
        $display("PASS: %0d", pass_count);
        $display("FAIL: %0d", fail_count);
        $display("--------------------------------");
    end

endmodule
