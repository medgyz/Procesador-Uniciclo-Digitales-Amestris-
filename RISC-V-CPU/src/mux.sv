// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 1
//
// Módulo: Multiplexor 2 a 1
//
// Descripción:
// Implementa un multiplexor 2 a 1 parametrizable que permite
// seleccionar una de dos entradas de datos.
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
// PARÁMETROS
// ------------------------------------------------------------
// WIDTH        : Cantidad de bits de las entradas y la salida.
//
// ENTRADAS
// ------------------------------------------------------------
// A            : Entrada 0.
// B            : Entrada 1.
// Select       : Señal de selección.
//
// SALIDAS
// ------------------------------------------------------------
// Y            : Entrada seleccionada.
// ============================================================

module mux2to1 #(parameter WIDTH = 32)
(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic             Select,
    output logic [WIDTH-1:0] Y
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================

    assign Y = Select ? B : A;

endmodule