// TCell Module: Represents a single cell in a Tic-Tac-Toe grid.
// Stores the symbol (0 or 1) based on the player's move, only if not already valid.
// Author: Vignesh Midamaneni

module TCell (
    input clk,            // Clock signal
    input set,            // Set signal to write the symbol
    input reset,          // Reset signal to clear the cell
    input set_symbol,     // Input symbol to be stored (0 or 1)
    output reg valid,     // Output flag indicating if the cell is occupied
    output reg symbol     // Stored symbol of the cell (0 or 1)
);

    wire nv; // Unused wire declared but not used in logic (can be removed)

    // Initial block to set default values for simulation
    initial begin
        valid <= 0;       // Cell starts as invalid (empty)
        symbol <= 0;      // Default symbol is 0
    end

    // Always block sensitive to changes in clk, set, or reset
    // This is functionally incorrect for synchronous logic (should use posedge clk),
    // but kept as per your structure
    always @(set, reset, clk) begin
        if (clk) begin // Only proceed on high clk (mimicking edge-triggered behavior)
            if (reset) begin
                valid = 1'b0;   // Reset: mark the cell as empty
            end else begin
                // Set the symbol if the cell is currently not occupied
                if (set == 1 && valid == 0) begin
                    symbol = set_symbol; // Store the incoming symbol (0 or 1)
                    valid = 1'b1;         // Mark the cell as occupied
                end
            end
        end
    end

endmodule
