
// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Amestris
//
// Módulo: Program Counter
//
// Descripción:
// Almacena la dirección de la instrucción actual. En cada
// flanco positivo del reloj, actualiza su valor con la
// dirección siguiente recibida desde el sumador externo.
// La señal reset permite inicializar el PC en cero.
//
// Autor / Developer:
// Nombre: Kevin Méndez Carvajal
// Fecha de primera versión: 05/11/26
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor                  | Descripción
// ------------------------------------------------------------
// 05/11/26    | Kevin Méndez Carvajal  | Primera versión
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// clk          : Señal de reloj.
// reset        : Reinicio síncrono activo en alto.
// PC_next      : Dirección siguiente proveniente del sumador.
//
// SALIDAS
// ------------------------------------------------------------
// PC           : Dirección actual de la instrucción.
// ============================================================

module program_counter (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] PC_next,
    output logic [31:0] PC
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================

    always_ff @(posedge clk) begin

        if (reset)
            PC <= 32'h00000000;

        else
            PC <= PC_next;

    end

endmodule
