module m_design (
    input logic clk100, // 100MHz clock
    input logic reset_n, // Active-low reset

    output logic [7:0] base_led, // LEDs on the far right side of the board
    output logic [23:0] led, // LEDs in the middle of the board

    input logic [23:0] sw, // The tiny slide-switches

    input logic urx,
    output logic utx,

    output logic [3:0] display_sel, // Select between the 4 segments
    output logic [7:0] display // Seven-segment display
);

    logic clk;

    uwuifier #(
        .CLK_FREQ(25000000),
        .BAUD(115200)
    ) dut (
        .clk(clk),
        .rst(sw[0]),
        .rx(urx),
        .tx(utx),
        .dbg(led)
    );

    // 100MHz -> 25MHz
    SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),
        .DIVR(4'b0000),         // DIVR =  0
        .DIVF(7'b0000111),      // DIVF =  7
        .DIVQ(3'b101),          // DIVQ =  5
        .FILTER_RANGE(3'b101)   // FILTER_RANGE = 5
    ) pll (
        .LOCK(),
        .RESETB(1'b1),
        .BYPASS(1'b0),
        .REFERENCECLK(clk100),
        .PLLOUTCORE(clk)
    );

endmodule
