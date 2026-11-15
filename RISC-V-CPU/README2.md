
# Procesador RISC-V uniciclo — Proyecto Final, Capítulo 2

**Curso:** EL-3310 Diseño de Sistemas Digitales — Instituto Tecnológico de Costa Rica

**Profesor:** Ing. Michael González Vega

**Grupo:** Amestris

**Entrega:** 15 de noviembre de 2026

Procesador RISC-V (RV32I parcial) uniciclo escrito en SystemVerilog. Ejecuta una instrucción por ciclo, con PC secuencial (`PC_next = PC + 4`). Esta etapa no incluye saltos ni bifurcaciones (Capítulo 3).

## Integrantes y roles

| Integrante | Rol |
|---|---|
| Kevin Méndez Carvajal | Diseño e implementación del hardware (módulos nuevos e integración) |
| John Hibbert Bonilla | Verificación (testbench de integración) |
| Ximena Araya Brenes | Documentación (informe, README, matriz de pruebas) |
| Jason Ulloa | [CONFIRMAR ROL] |

> No se comunicaron cambios de roles al profesor antes del 1 de noviembre de 2026 [CONFIRMAR].

## Instrucciones soportadas

| Instrucción | Formato | Operación |
|---|---|---|
| `add rd, rs1, rs2` | R | `rd = rs1 + rs2` |
| `sub rd, rs1, rs2` | R | `rd = rs1 - rs2` |
| `and rd, rs1, rs2` | R | `rd = rs1 & rs2` |
| `or rd, rs1, rs2` | R | `rd = rs1 \| rs2` |
| `addi rd, rs1, imm` | I | `rd = rs1 + imm` |
| `lw rd, imm(rs1)` | I | `rd = Mem[rs1 + imm]` |
| `sw rs2, imm(rs1)` | S | `Mem[rs1 + imm] = rs2` |

Las instrucciones no soportadas no modifican registros ni memoria (todas las señales de control quedan en su valor por defecto).

## Estructura del repositorio

```
src/
  alu.sv                  # Cap. 1 (ALUControl: ADD=0000, SUB=0001, AND=0010, OR=0011)
  register_file.sv        # Cap. 1 (lectura combinacional, escritura en flanco positivo, x0 = 0)
  imm_gen.sv              # Cap. 1 (ImmSrc: I-type = 00, S-type = 01)
  mux.sv                  # Cap. 1 (módulo mux2to1, parametrizable con WIDTH)
  program_counter.sv      # Nuevo
  instruction_memory.sv   # Nuevo
  data_memory.sv          # Nuevo
  control_unit.sv         # Nuevo
  riscv_uniciclo.sv       # Nuevo: top / datapath
testbench/
  alu_tb.sv  imm_gen_tb.sv  mux_tb.sv  register_file_tb.sv   # Pruebas unitarias (Cap. 1)
  tb_riscv_top.sv         # Integración: programa ilustrativo + programa propio
  tb_extra.sv             # Integración: reset, secuencia de PC, x0, instrucción no soportada
programs/
  program_custom.mem      # Programa propio en hexadecimal (referencia; ver nota abajo)
docs/
  datapath.png            # Diagrama propio del datapath
  informe.pdf             # Informe técnico
  informe.tex
README.md
```

## Cómo simular

### EDA Playground

Enlace a la simulación de integración: <https://edaplayground.com/x/gTCg>

### Local (Icarus Verilog)

```bash
iverilog -g2012 -o sim_int src/*.sv testbench/tb_riscv_top.sv
vvp sim_int

# Pruebas adicionales (reset, PC, x0, instrucción no soportada)
iverilog -g2012 -o sim_extra src/*.sv testbench/tb_extra.sv
vvp sim_extra
```

Cada comprobación imprime `[PASS]` o `[FAIL]` con el valor obtenido y el esperado; `tb_riscv_top` cierra con un resumen `SYSTEM PASS` / `SYSTEM FAIL`.

### Cómo se carga el programa

`instruction_memory` no lee archivos, el testbench escribe las instrucciones de forma jerárquica (`dut.IMEM.memi[i] = 32'h...`) antes de liberar el reset. 

## Consideraciones importantes del diseño

- **Reset:** síncrono, activo en alto. En el flanco positivo con `reset = 1`, `PC <= 0x00000000`.
- **Memorias:** 256 palabras de 32 bits cada una (1 KiB). Se utilizan con `Address[9:2]` (la dirección de byte se divide entre 4); los bits `[1:0]` no se toman en cuenta. Direcciones por encima de `0x3FC` se repiten.
- **Instruction Memory / Data Memory:** lectura combinacional; escritura de datos síncrona con `MemWrite`.
- **Banco de registros:** lecturas combinacionales, escritura en flanco positivo con `RegWrite`; `x0` siempre vale 0 y no se puede escribir.
- **Señal `Zero` de la ALU:** está implementada pero todavía no se usa.

## Resultados

| Verificación | Resultado |
|---|---|
| Integración: programa ilustrativo (6 comprobaciones) | 6/6 PASS |
| Integración: programa propio, 7 instrucciones (8 comprobaciones) | 8/8 PASS |
| Pruebas adicionales (reset, PC, x0, no soportada, lw/sw) | 12/12 PASS |
| Unitarias Cap. 1: ALU | 6/7 (ALU-07 falla por valor esperado erróneo en el testbench; ver informe) |
| Unitarias Cap. 1: Imm. Gen., MUX, Register File | 5/5, 4/4, 4/4 |

AÑADIR MATRIZ DE PRUEBAS


