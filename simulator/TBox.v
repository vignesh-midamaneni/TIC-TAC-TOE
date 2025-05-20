// TBox.v
// Author: Vignesh Midamaneni
// Description: TBox module for Tic-Tac-Toe game logic using TCell grid

`include "Tcell.v"
`include "row_column_decoder.v"
`include "mux.v"

module TBox (
    input clk,          // Clock signal
    input set,          // Set signal (attempt to make a move)
    input reset,        // Reset signal
    input [1:0] row,    // Row input (2-bit)
    input [1:0] col,    // Column input (2-bit)
    output [8:0] valid, // Valid signals for each cell
    output [8:0] symbol,// Symbol stored in each cell (0 for O, 1 for X)
    output [1:0] game_state // Game result: 00 - ongoing, 01 - X wins, 10 - O wins
);

    wire [8:0] s1, s;

    // Decode the row and column to one-hot select signal for the 3x3 grid
    row_column_decoder rc1(row, col, s1);

    // Compute write-enable signal for each cell (only if game not finished and set is high)
    assign s[0] = s1[0] & set & ~game_state[0] & ~game_state[1];
    assign s[1] = s1[1] & set & ~game_state[0] & ~game_state[1];
    assign s[2] = s1[2] & set & ~game_state[0] & ~game_state[1];
    assign s[3] = s1[3] & set & ~game_state[0] & ~game_state[1];
    assign s[4] = s1[4] & set & ~game_state[0] & ~game_state[1];
    assign s[5] = s1[5] & set & ~game_state[0] & ~game_state[1];
    assign s[6] = s1[6] & set & ~game_state[0] & ~game_state[1];
    assign s[7] = s1[7] & set & ~game_state[0] & ~game_state[1];
    assign s[8] = s1[8] & set & ~game_state[0] & ~game_state[1];

    // Determine whose turn it is: 0 = X, 1 = O
    wire set_symbol;
    xor (set_symbol, valid[0], valid[1], valid[2], valid[3], valid[4],
                     valid[5], valid[6], valid[7], valid[8]);

    // 3x3 Grid of TCells representing the game board
    TCell t1(clk, s[0], reset, ~set_symbol, valid[0], symbol[0]);
    TCell t2(clk, s[1], reset, ~set_symbol, valid[1], symbol[1]);
    TCell t3(clk, s[2], reset, ~set_symbol, valid[2], symbol[2]);
    TCell t4(clk, s[3], reset, ~set_symbol, valid[3], symbol[3]);
    TCell t5(clk, s[4], reset, ~set_symbol, valid[4], symbol[4]);
    TCell t6(clk, s[5], reset, ~set_symbol, valid[5], symbol[5]);
    TCell t7(clk, s[6], reset, ~set_symbol, valid[6], symbol[6]);
    TCell t8(clk, s[7], reset, ~set_symbol, valid[7], symbol[7]);
    TCell t9(clk, s[8], reset, ~set_symbol, valid[8], symbol[8]);

    // Check game state (X win, O win, or draw)
    wire [1:0] state;
    state_check c1(symbol, valid, state);

    // Check if the board is full
    wire val;
    assign val = &valid;

    // Select line for game state update
    wire sel;
    and (sel, val, ~state[0], ~state[1]); // Full board & no winner => draw

    // Use muxes to output final game state
    mux m1({state[0], 1'b1}, sel, game_state[0]); // X win or draw
    mux m2({state[1], 1'b1}, sel, game_state[1]); // O win or draw

endmodule

// -------------------
// State Checker Module
// -------------------
// Description: Checks all possible win conditions for a 3x3 Tic-Tac-Toe board
module state_check (
    input [8:0] sym,   // Symbol array (1=X, 0=O)
    input [8:0] val,   // Valid bit for each cell
    output [1:0] state // Output state: 00=ongoing, 01=X wins, 10=O wins
);

    // Declare intermediate wires
    wire winx1, winx2, winx3, winx4, winx5, winx6, winx7, winx8;
    wire wino1, wino2, wino3, wino4, wino5, wino6, wino7, wino8;
    wire v1, v2, v3, v4, v5, v6, v7, v8;

    // Check all possible winning lines

    // Row 1
    and (v1, val[0], val[1], val[2]);
    and (winx1, v1, sym[0], sym[1], sym[2]);
    nor (wino1, ~v1, sym[0], sym[1], sym[2]);

    // Row 2
    and (v2, val[3], val[4], val[5]);
    and (winx2, v2, sym[3], sym[4], sym[5]);
    nor (wino2, ~v2, sym[3], sym[4], sym[5]);

    // Row 3
    and (v3, val[6], val[7], val[8]);
    and (winx3, v3, sym[6], sym[7], sym[8]);
    nor (wino3, ~v3, sym[6], sym[7], sym[8]);

    // Column 1
    and (v4, val[0], val[3], val[6]);
    and (winx4, v4, sym[0], sym[3], sym[6]);
    nor (wino4, ~v4, sym[0], sym[3], sym[6]);

    // Column 2
    and (v5, val[1], val[4], val[7]);
    and (winx5, v5, sym[1], sym[4], sym[7]);
    nor (wino5, ~v5, sym[1], sym[4], sym[7]);

    // Column 3
    and (v6, val[2], val[5], val[8]);
    and (winx6, v6, sym[2], sym[5], sym[8]);
    nor (wino6, ~v6, sym[2], sym[5], sym[8]);

    // Diagonal 1
    and (v7, val[0], val[4], val[8]);
    and (winx7, v7, sym[0], sym[4], sym[8]);
    nor (wino7, ~v7, sym[0], sym[4], sym[8]);

    // Diagonal 2
    and (v8, val[2], val[4], val[6]);
    and (winx8, v8, sym[2], sym[4], sym[6]);
    nor (wino8, ~v8, sym[2], sym[4], sym[6]);

    // Output: state[0]=X wins, state[1]=O wins
    or (state[0], winx1, winx2, winx3, winx4, winx5, winx6, winx7, winx8);
    or (state[1], wino1, wino2, wino3, wino4, wino5, wino6, wino7, wino8);

endmodule
