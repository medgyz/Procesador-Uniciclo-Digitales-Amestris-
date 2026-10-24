// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 1
//
// Testbench: Multiplexor 2 a 1
//
// Descripción:
// Verifica que el multiplexor seleccione correctamente cada
// una de sus entradas según la señal Select.
//
// Autor / Verification Engineer:
// Nombre: ______________________________
// Fecha de primera versión: ____/____/______
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripción
// ------------------------------------------------------------
// 20/10/2026  | John Hibbert Bonilla  | Primera versión
//
// ============================================================

module mux_tb;

    logic [31:0] A;
    logic [31:0] B;
    logic        Select;
    logic [31:0] Y;
    integer pass_count = 0;
    integer fail_count = 0;
    mux2to1 #(.WIDTH(32)) dut (
        .A(A),
        .B(B),
        .Select(Select),
        .Y(Y)
    );

    initial begin

        A = 32'h12345678;
        B = 32'hABCDEF00;

        // ====================================================
        // TEST 1 - Select = 0
        // ====================================================

        Select = 0;
        #10;
                if (Y === A) begin
            $display("MUX-01 | SELECT-A | PASS | Y=%h", Y);
            pass_count = pass_count + 1;
        end
        else begin
            $display("MUX-01 | SELECT-A | FAIL | Y=%h | Esperado=%h", Y, A);
            fail_count = fail_count + 1;
        end
        // ====================================================
        // TEST 2 - Select = 1
        // ====================================================

        Select = 1;
        #10;

        if (Y === B) begin
            $display("MUX-02 | SELECT-B | PASS | Y=%h", Y);
            pass_count = pass_count + 1;
        end
        else begin
            $display("MUX-02 | SELECT-B | FAIL | Y=%h | Esperado=%h", Y, B);
            fail_count = fail_count + 1;
        end

        // ====================================================
        // TEST 3 - Prueba adicional
        // ====================================================

        A = 32'h0000000A;
        B = 32'h00000014;

        Select = 0;
        #10;

        if (Y === A) begin
            $display("MUX-03A | SELECT-A | PASS | Y=%h", Y);
            pass_count = pass_count + 1;
        end
        else begin
            $display("MUX-03A | SELECT-A | FAIL | Y=%h | Esperado=%h", Y, A);
            fail_count = fail_count + 1;
        end

        Select = 1;
        #10;

        if (Y === B) begin
            $display("MUX-03B | SELECT-B | PASS | Y=%h", Y);
            pass_count = pass_count + 1;
        end
        else begin
            $display("MUX-03B | SELECT-B | FAIL | Y=%h | Esperado=%h", Y, B);
            fail_count = fail_count + 1;
        end

        $display("--------------------------------");
        $display("Resumen de pruebas del MUX");
        $display("PASS: %0d", pass_count);
        $display("FAIL: %0d", fail_count);
        $display("--------------------------------");
        $finish;
    end

endmodule
