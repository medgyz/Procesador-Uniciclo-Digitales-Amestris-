// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Amestris
//
// Módulo: Data Memory
//
// Descripción:
// Almacena datos de 32 bits. Permite la lectura combinacional
// y la escritura síncrona de datos mediante la señal MemWrite.
//
// Autor / Developer:
// Nombre: Kevin Méndez Carvajal
// Fecha de primera versión: 06/11/26
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                  | Descripción
// ------------------------------------------------------------
// 06/11/26    | Kevin Méndez Carvajal  | Primera versión
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// clk          : Señal de reloj.
// MemWrite     : Habilitación de escritura.
// Address      : Dirección de byte de memoria.
// WriteData    : Dato que se desea almacenar.
//
// SALIDAS
// ------------------------------------------------------------
// ReadData     : Dato leído de la memoria.
// ============================================================

module data_memory (

    input  logic        clk,
    input  logic        MemWrite,
    input  logic [31:0] Address,
    input  logic [31:0] WriteData,
    output logic [31:0] ReadData

);

    // ========================================================
    // DECLARACIÓN DE MEMORIA
    // ========================================================

    logic [31:0] memd [0:255];

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================

    // Lectura combinacional
    always_comb begin

        ReadData = memd[Address[9:2]];

    end

    // Escritura síncrona
    always_ff @(posedge clk) begin

        if (MemWrite)
            memd[Address[9:2]] <= WriteData;

    end

endmodule
