// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 1
//
// Testbench: Register File
//
// Descripción:
// Verifica las operaciones de lectura y escritura del banco de
// registros, incluyendo el comportamiento especial de x0.
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

module register_file_tb;

    logic        clk;
    logic [4:0]  A1;
    logic [4:0]  A2;
    logic [4:0]  A3;
    logic [31:0] WD3;
    logic        RegWrite;
    logic [31:0] RD1;
    logic [31:0] RD2;
    integer pass_count = 0;
    integer fail_count = 0;
    register_file dut (
        .clk(clk),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .RegWrite(RegWrite),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Generación de reloj
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin

        // Inicialización
        RegWrite = 0;
        A1 = 0;
        A2 = 0;
        A3 = 0;
        WD3 = 0;

        // ====================================================
        // TEST 1 - Escritura y lectura de un registro
        // ====================================================

        A3 = 5'd1;
        WD3 = 32'd25;
        RegWrite = 1;

        @(posedge clk);
        #1;

        RegWrite = 0;
        A1 = 5'd1;
        #1;

        if (RD1 === 32'd25) begin
            $display("RF-01 | WRITE-READ | PASS | Registro=1, Dato=%0d", RD1);
            pass_count = pass_count + 1;
        end
        else begin
            $display("RF-01 | WRITE-READ | FAIL | Registro=1, Dato=%0d, Esperado=25", RD1);
            fail_count = fail_count + 1;
        end

        // ====================================================
        // TEST 2 - Lectura simultánea
        // ====================================================
                A3 = 5'd2;
        WD3 = 32'd40;
        RegWrite = 1;

        @(posedge clk);
        #1;

        A3 = 5'd3;
        WD3 = 32'd60;

        @(posedge clk);
        #1;

        RegWrite = 0;
        A1 = 5'd2;
        A2 = 5'd3;

        #1;

        if ((RD1 === 32'd40) && (RD2 === 32'd60)) begin
            $display("RF-02 | DUAL-READ | PASS | RD1=%0d, RD2=%0d", RD1, RD2);
            pass_count = pass_count + 1;
        end
        else begin
            $display("RF-02 | DUAL-READ | FAIL | RD1=%0d, RD2=%0d | Esperado: RD1=40, RD2=60", RD1, RD2);
            fail_count = fail_count + 1;
        end

        // ====================================================
        // TEST 3 - Registro x0
        // ====================================================
                A3 = 5'd0;
        WD3 = 32'd99;
        RegWrite = 1;

        @(posedge clk);
        #1;

        RegWrite = 0;
        A1 = 5'd0;

        #1;

        if (RD1 === 32'd0) begin
            $display("RF-03 | X0 | PASS | RD1=%0d", RD1);
            pass_count = pass_count + 1;
        end
        else begin
            $display("RF-03 | X0 | FAIL | RD1=%0d | Esperado=0", RD1);
            fail_count = fail_count + 1;
        end

        // ====================================================
        // TEST 4 - RegWrite deshabilitado
        // ====================================================
               A3 = 5'd4;
        WD3 = 32'd75;
        RegWrite = 1;

        @(posedge clk);
        #1;

        RegWrite = 0;
        WD3 = 32'd100;

        @(posedge clk);
        #1;

        A1 = 5'd4;
        #1;

        if (RD1 === 32'd75) begin
            $display("RF-04 | REGWRITE-OFF | PASS | RD1=%0d", RD1);
            pass_count = pass_count + 1;
        end
        else begin
            $display("RF-04 | REGWRITE-OFF | FAIL | RD1=%0d | Esperado=75", RD1);
            fail_count = fail_count + 1;
        end

        $display("--------------------------------");
        $display("Resumen de pruebas del Registro File");
        $display("PASS: %0d", pass_count);
        $display("FAIL: %0d", fail_count);
        $display("--------------------------------");
        $finish;
    end

endmodule
