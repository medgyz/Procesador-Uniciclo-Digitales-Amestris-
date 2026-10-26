# Proyecto_Final_-_Capítulo_1:_Los_Cimientos

**Curso:** Diseño de Sistemas Digitales (EL-3310)  
**Institución:** Instituto Tecnológico de Costa Rica (TEC)  
**Profesor:** Ing. Michael González Vega  

---

## Integrantes del Grupo

* **Team Lead:**  Ximena Araya Brenes - Carné: 2024122095
* **Hardware Developer:**  Kevin Mendez Carvajal - Carné: 2023328177
* **Verification Engineer:** John Hibbert Bonilla - Carné: 2024062788
* **Documentation & Configuration Engineer:** Jason Enrique Ulloa Picado - Carné: 2024159001

---

## Estructura del Proyecto

```text
RISC-V-CPU/
├── src/                    # Código fuente de los módulos SystemVerilog
│   ├── alu.sv              # Unidad Aritmético Lógica
│   ├── register_file.sv    # Banco de Registros (32x32 bits)
│   ├── imm_gen.sv          # Generador de Inmediatos (I-type, S-type)
│   └── mux.sv              # Multiplexor 2:1
├── testbench/              # Testbenches para verificación funcional
│   ├── alu_tb.sv
│   ├── register_file_tb.sv
│   ├── imm_gen_tb.sv
│   └── mux_tb.sv
├── sim/                    # Archivos y resultados de simulación
│   ├── alu_sim
│   ├── imm_sim
│   ├── mux_sim
│   └── rf_sim
├── docs/                   # Documentación técnica e informe
│   └── Informe de Proyecto - DD/
└── README.md               # Archivo de presentación y enlaces
```

---

## Simulaciones en EDA Playground

Para abrir y ejecutar la simulación de cada módulo, acceda a los siguientes enlaces de EDA Playground:

**ALU:** <https://edaplayground.com/x/MBYt>

**Register File:** <https://edaplayground.com/x/i8qn>

**Immediate Generator:** <https://edaplayground.com/x/T888>

**MUX:** <https://edaplayground.com/x/dvgr>

---

## Matriz de Pruebas Funcionales

La matriz de pruebas ejecutada para la verificación funcional de todos los módulos SystemVerilog (incluyendo la prueba de inyección de falla controlada en la ALU para validar la autocomprobación del testbench) es:

| ID | Módulo | Entrada / Condición | Resultado Esperado | Resultado Obtenido | Estado |
| :--- | :--- | :--- | :--- | :--- | :---: |
| **ALU-01** | ALU | Operación ADD: `A = 5, B = 3, ALUControl = 0000` | `Result = 8, Zero = 0` | `Result = 8, Zero = 0` | **PASS** |
| **ALU-02** | ALU | Operación SUB: `A = 5, B = 3, ALUControl = 0001` | `Result = 2, Zero = 0` | `Result = 2, Zero = 0` | **PASS** |
| **ALU-03** | ALU | Operación AND: `A = 5, B = 3, ALUControl = 0010` | `Result = 1, Zero = 0` | `Result = 1, Zero = 0` | **PASS** |
| **ALU-04** | ALU | Operación OR: `A = 5, B = 3, ALUControl = 0011` | `Result = 7, Zero = 0` | `Result = 7, Zero = 0` | **PASS** |
| **ALU-05** | ALU | Detección de Cero (ZERO): `A = 5, B = 5, ALUControl = 0001` | `Result = 0, Zero = 1` | `Result = 0, Zero = 1` | **PASS** |
| **ALU-06** | ALU | Resultado Negativo (SUB): `A = 3, B = 5, ALUControl = 0001` | `Result = -2 (0xFFFFFFFE), Zero = 0` | `Result = -2 (0xFFFFFFFE), Zero = 0` | **PASS** |
| **ALU-07** | ALU | Prueba de Inyección de Falla: `A = 5, B = 3, ALUControl = 0000` | `Result = 9` *(Prueba de falla)* | `Result = 8` | **FAIL** *(Esperado)* |
| **RF-01** | Register File | Escritura y lectura en x1: `A3 = 1, WD3 = 25, RegWrite = 1` | `RD1 = 25` | `RD1 = 25` | **PASS** |
| **RF-02** | Register File | Lectura dual simultánea: `A1 = 1 (40), A2 = 2 (60)` | `RD1 = 40, RD2 = 60` | `RD1 = 40, RD2 = 60` | **PASS** |
| **RF-03** | Register File | Intento de escritura en x0: `A3 = 0, WD3 = 100, RegWrite = 1` | `RD1 = 0` | `RD1 = 0` | **PASS** |
| **RF-04** | Register File | Escritura deshabilitada (`RegWrite = 0`): `A3 = 3, WD3 = 99` | `RD1 = 75` *(Valor sin cambios)* | `RD1 = 75` | **PASS** |
| **IMM-01** | Imm Gen | I-type positivo: `instr (Imm = 5), ImmSrc = 00` | `ImmExt = 0x00000005` | `ImmExt = 0x00000005` | **PASS** |
| **IMM-02** | Imm Gen | I-type negativo (Extensión de signo): `instr (Imm = -1), ImmSrc = 00` | `ImmExt = 0xFFFFFFFF` | `ImmExt = 0xFFFFFFFF` | **PASS** |
| **IMM-03** | Imm Gen | S-type positivo: `instr (Imm = 0), ImmSrc = 01` | `ImmExt = 0x00000000` | `ImmExt = 0x00000000` | **PASS** |
| **IMM-04** | Imm Gen | S-type negativo (Extensión de signo): `instr (Imm = -4), ImmSrc = 01` | `ImmExt = 0xFFFFFFFC` | `ImmExt = 0xFFFFFFFC` | **PASS** |
| **IMM-05** | Imm Gen | S-type positivo: `instr (Imm = 32), ImmSrc = 01` | `ImmExt = 0x00000020` | `ImmExt = 0x00000020` | **PASS** |
| **MUX-01** | MUX | Selección Entrada A: `d0 = 0x12345678, d1 = 0xABCDEF00, sel = 0` | `y = 0x12345678` | `y = 0x12345678` | **PASS** |
| **MUX-02** | MUX | Selección Entrada B: `d0 = 0x12345678, d1 = 0xABCDEF00, sel = 1` | `y = 0xABCDEF00` | `y = 0xABCDEF00` | **PASS** |
| **MUX-03A**| MUX | Alternancia Entrada A: `d0 = 0x0000000A, d1 = 0x00000014, sel = 0` | `y = 0x0000000A` | `y = 0x0000000A` | **PASS** |
| **MUX-03B**| MUX | Alternancia Entrada B: `d0 = 0x0000000A, d1 = 0x00000014, sel = 1` | `y = 0x00000014` | `y = 0x00000014` | **PASS** |

---

## Instrucciones de Ejecución

Abra cualquiera de los enlaces de EDA Playground.

Seleccionar las herramientas de simulación adecuadas en el panel izquierdo (ejemplo: Icarus Verilog o VNSim / Riviera-PRO habilitando SystemVerilog).

Haga clic en el botón Run para ejecutar la simulación.

Revise el panel de la consola (EPWave o la salida de texto) para verificar los mensajes automatizados de PASS / FAIL correspondientes a la matriz de pruebas
