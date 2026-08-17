module rptr_empty #(parameter ADDRESS_SIZE = 8)(
    output reg r_empty,                  
    output [ADDRESS_SIZE-1:0] r_addr,     
    output reg [ADDRESS_SIZE :0] r_ptr,  //read pointer(gray register)  
    input [ADDRESS_SIZE :0] r_q2_wptr,      
    input r_inc, r_clk, r_rst_n );

    reg [ADDRESS_SIZE:0] r_bin;                     // Binary register
    wire [ADDRESS_SIZE:0] r_gray_next, r_bin_next;   
    wire r_empty_val;                         

    // gray code pointer
    always @(posedge r_clk or negedge r_rst_n) begin
        if (!r_rst_n)               
            {r_bin, r_ptr} <= 1'b0;
        else 
            {r_bin, r_ptr} <= {r_bin_next, r_gray_next};  
    end

    assign r_addr = r_bin[ADDRESS_SIZE-1:0];                 
    assign r_bin_next = r_bin + (r_inc & ~r_empty);         
    assign r_gray_next = (r_bin_next>>1) ^ r_bin_next;     

    
    assign r_empty_val = (r_gray_next == r_q2_wptr);       

    always @(posedge r_clk or negedge r_rst_n) begin
        if (!r_rst_n)                
            r_empty <= 1'b1;
        else 
            r_empty <= r_empty_val;  
    end
endmodule
