// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Amestris
//
// Módulo: Testbench Data Memory (tb_data_memory)
//
// Descripción:
// Prueba unitaria autochequeada (PASS/FAIL) para el módulo
// data_memory. Verifica lectura combinacional, escritura
// síncrona en flanco positivo de reloj con MemWrite = 1,
// protección de memoria con MemWrite = 0, direccionamiento
// alineado a palabras (Address[9:2]) y posición final.
//
// Autor / Verification Engineer:
// Nombre: John Hibbert Bonilla
// Fecha de primera versión: 23/11/26
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                       | Descripción
// ------------------------------------------------------------
// 23/11/26    | John Hibbert Bonilla  | Primera versión
// ============================================================

`timescale 1ns / 1ps

module tb_data_memory;

    logic        clk;
    logic        MemWrite;
    logic [31:0] Address;
    logic [31:0] WriteData;
    logic [31:0] ReadData;

    int          errors_count = 0;

    data_memory dut (
        .clk(clk),
        .MemWrite(MemWrite),
        .Address(Address),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

    always #5 clk = ~clk;

    initial begin
        clk       = 1'b0;
        MemWrite  = 1'b0;
        Address   = 32'h00000000;
        WriteData = 32'h00000000;

        $display("\n==================================================");
        $display("   TESTBENCH UNITARIO: DATA MEMORY                ");
        $display("==================================================\n");

        // Precarga inicial para probar lectura directa
        dut.memd[0] = 32'h00000014; // 20 en decimal
        Address     = 32'h00000000;
        #2;
        if (ReadData === 32'h00000014)
            $display("[PASS] TC-DMEM-01: Lectura en Address 0x00 -> %0d", ReadData);
        else begin
            $display("[FAIL] TC-DMEM-01: Address 0x00 -> %0d (Esperado: 20)", ReadData);
            errors_count++;
        end

        // TC-DMEM-02: Escritura síncrona en Address 0x04 (memd[1]) con MemWrite = 1
        Address   = 32'h00000004;
        WriteData = 32'd22;
        MemWrite  = 1'b1;
        @(posedge clk);
        #1;
        MemWrite  = 1'b0;
        if (dut.memd[1] === 32'd22 && ReadData === 32'd22)
            $display("[PASS] TC-DMEM-02: Escritura en Mem[4] -> ReadData = %0d", ReadData);
        else begin
            $display("[FAIL] TC-DMEM-02: Mem[4] -> %0d (Esperado: 22)", ReadData);
            errors_count++;
        end

        // TC-DMEM-03: Con MemWrite = 0 no debe sobrescribir en flanco de reloj
        WriteData = 32'd99;
        MemWrite  = 1'b0;
        @(posedge clk);
        #1;
        if (ReadData === 32'd22)
            $display("[PASS] TC-DMEM-03: Escritura bloqueada con MemWrite=0 -> %0d", ReadData);
        else begin
            $display("[FAIL] TC-DMEM-03: Se sobrescribió con MemWrite=0 -> %0d (Esperado: 22)", ReadData);
            errors_count++;
        end

        // TC-DMEM-04: Alineación a palabra (Address 0x06 apunta a memd[1])
        Address = 32'h00000006;
        #2;
        if (ReadData === 32'd22)
            $display("[PASS] TC-DMEM-04: Alineación Address 0x06 -> memd[1] = %0d", ReadData);
        else begin
            $display("[FAIL] TC-DMEM-04: Alineación Address 0x06 -> %0d (Esperado: 22)", ReadData);
            errors_count++;
        end

        // TC-DMEM-05: Escritura y lectura en última palabra memd[255] (Address 0x3FC)
        Address   = 32'h000003FC;
        WriteData = 32'hCAFEBABE;
        MemWrite  = 1'b1;
        @(posedge clk);
        #1;
        MemWrite  = 1'b0;
        if (ReadData === 32'hCAFEBABE)
            $display("[PASS] TC-DMEM-05: Dirección límite 0x3FC -> 0x%h", ReadData);
        else begin
            $display("[FAIL] TC-DMEM-05: Dirección límite 0x3FC -> 0x%h (Esperado: CAFEBABE)", ReadData);
            errors_count++;
        end

        $display("\n==================================================");
        if (errors_count == 0)
            $display("   RESULTADO DATA MEMORY: UNIT PASS               ");
        else
            $display("   RESULTADO DATA MEMORY: UNIT FAIL (%0d)      ", errors_count);
        $display("==================================================\n");

        $finish;
    end

endmodule