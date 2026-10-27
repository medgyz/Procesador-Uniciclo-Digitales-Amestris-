// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 1
//
// Módulo: Register File
//
// Descripción:
// Implementa el banco de 32 registros de 32 bits del procesador.
// Permite leer dos registros simultáneamente y escribir un
// registro cuando la señal RegWrite está habilitada.
//
// Autor / Developer:
// Nombre: Kevin Méndez Carvajal
// Fecha de primera versión: 11/10/26
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                  | Descripción
// ------------------------------------------------------------
// 11/10/26    | Kevin Méndez Carvajal   | Primera versión
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// clk          : Señal de reloj.
// A1           : Dirección del primer registro a leer.
// A2           : Dirección del segundo registro a leer.
// A3           : Dirección del registro a escribir.
// WD3          : Dato de 32 bits que será escrito.
// RegWrite     : Habilita la escritura en el banco de registros.
//
// SALIDAS
// ------------------------------------------------------------
// RD1          : Dato leído del registro seleccionado por A1.
// RD2          : Dato leído del registro seleccionado por A2.
//
// CONDICIÓN ESPECIAL
// ------------------------------------------------------------
// El registro x0 debe conservar siempre el valor 0.
// ============================================================

module register_file (
    input  logic        clk,
    input  logic [4:0]  A1,
    input  logic [4:0]  A2,
    input  logic [4:0]  A3,
    input  logic [31:0] WD3,
    input  logic        RegWrite,
    output logic [31:0] RD1,
    output logic [31:0] RD2
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================

    // Banco de 32 registros, cada uno de 32 bits.
    logic [31:0] registros [0:31];

    // Escritura en el flanco de subida del reloj.
    always_ff @(posedge clk) begin
        if (RegWrite && (A3 != 5'd0))
            registros[A3] <= WD3;
    end

    // Lectura combinacional de los dos puertos.
    always_comb begin

        // Primer puerto de lectura.
        if (A1 == 5'd0)
            RD1 = 32'd0;
        else
            RD1 = registros[A1];

        // Segundo puerto de lectura.
        if (A2 == 5'd0)
            RD2 = 32'd0;
        else
            RD2 = registros[A2];

    end

endmodule