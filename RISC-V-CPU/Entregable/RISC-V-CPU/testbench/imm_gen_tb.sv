// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 1
//
// Testbench: Immediate Generator
//
// Descripción:
// Verifica la generación y extensión de los valores inmediatos
// requeridos durante el Capítulo 1 del proyecto.
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

module imm_gen_tb;

    logic [31:0] Instr;
    logic [1:0]  ImmSrc;
    logic [31:0] ImmExt;
    integer pass_count = 0;
    integer fail_count = 0;
    imm_gen dut (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    initial begin

        // ====================================================
        // TEST 1 - Inmediato tipo I positivo
        // ====================================================
                Instr = 32'h00500093;
        ImmSrc = 2'b00;

        #10;

        if (ImmExt === 32'd5) begin
            $display("IMM-01 | I-POSITIVE | PASS | ImmExt=%0d", ImmExt);
            pass_count = pass_count + 1;
        end
        else begin
            $display("IMM-01 | I-POSITIVE | FAIL | ImmExt=%0d | Esperado=5", ImmExt);
            fail_count = fail_count + 1;
        end

        // ====================================================
        // TEST 2 - Inmediato tipo I negativo
        // ====================================================
                Instr = 32'hFFF00093;
        ImmSrc = 2'b00;

        #10;

        if (ImmExt === 32'hFFFFFFFF) begin
            $display("IMM-02 | I-NEGATIVE | PASS | ImmExt=%h", ImmExt);
            pass_count = pass_count + 1;
        end
        else begin
            $display("IMM-02 | I-NEGATIVE | FAIL | ImmExt=%h | Esperado=FFFFFFFF", ImmExt);
            fail_count = fail_count + 1;
        end

        // ====================================================
        // TEST 3 - Inmediato tipo S positivo
        // ====================================================
               Instr = 32'h0020A023;
        ImmSrc = 2'b01;

        #10;

        if (ImmExt === 32'd0) begin
            $display("IMM-03 | S-POSITIVE | PASS | ImmExt=%0d", ImmExt);
            pass_count = pass_count + 1;
        end
        else begin
            $display("IMM-03 | S-POSITIVE | FAIL | ImmExt=%0d | Esperado=0", ImmExt);
            fail_count = fail_count + 1;
        end

        // ====================================================
        // TEST 4 - Inmediato tipo S negativo
        // ====================================================
                Instr = 32'hFE20AE23;
        ImmSrc = 2'b01;

        #10;

        if (ImmExt === 32'hFFFFFFFC) begin
            $display("IMM-04 | S-NEGATIVE | PASS | ImmExt=%h", ImmExt);
            pass_count = pass_count + 1;
        end
        else begin
            $display("IMM-04 | S-NEGATIVE | FAIL | ImmExt=%h | Esperado=FFFFFFFC", ImmExt);
            fail_count = fail_count + 1;
        end


        // ====================================================
        // TEST 5 - Inmediato tipo S positivo diferente de cero
        // ====================================================
        Instr = 32'h0020AA23;
        ImmSrc = 2'b01;

        #10;

        if (ImmExt === 32'd20) begin
            $display("IMM-05 | S-POSITIVE | PASS | ImmExt=%0d", ImmExt);
            pass_count = pass_count + 1;
        end
        else begin
            $display("IMM-05 | S-POSITIVE | FAIL | ImmExt=%0d | Esperado=20", ImmExt);
            fail_count = fail_count + 1;
        end


        $display("--------------------------------");
        $display("Resumen de pruebas del Inmediato Generador");
        $display("PASS: %0d", pass_count);
        $display("FAIL: %0d", fail_count);
        $display("--------------------------------");
        $finish;
    end

endmodule
