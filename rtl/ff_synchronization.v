module ff_synchronization #(parameter ADDRESS_SIZE = 8)( 
    output reg [ADDRESS_SIZE:0] q2,   // synchronized input
    input [ADDRESS_SIZE:0] data_in,       // Data input
    input clk, rst_n);

    reg [ADDRESS_SIZE:0] q1; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            {q2, q1} <= 0;         
        else 
            {q2, q1} <= {q1, data_in}; 
    end 

endmodule
