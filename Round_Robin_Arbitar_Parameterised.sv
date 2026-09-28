/*
Design Name :- Parameterised Round Robin Arbitar
Designer :- Siddharth (aiesec.siddharth1@gmail.com)
Date :- 28th Sep 2026
This is a parameterised round robin arbitar code. Current code is 4 bit arbitar.
TB added for testing
*/
module rr #(parameter N = 4) (clk,rst_n,granted,req);

//parameter declaration
parameter PTR_WIDTH = $clog2(N);
//Clock and Reset

input logic clk,rst_n;

//Request
input logic [N-1:0] req;

//Grant
output reg [N-1:0] granted;

//Internal Signals
logic found;
logic [PTR_WIDTH-1:0] idx,next_ptr;
reg [N-1:0] gnt;
int i,j,k;

//Sequential block for grant
always_ff @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                granted <= '0;
                end
            else begin
                granted <= gnt;
              end
              end

//Combinational Block for next pointer update
always_comb begin
        next_ptr = '0;
        for (k = 0; k < N ; k++) begin
             if (granted[k])
                 next_ptr = k + 1;
             else
                 next_ptr = next_ptr;
        end
        end

//Combinational Block for req check / grant
always_comb begin
        gnt = '0;
        found = '0;
        idx = '0;
        for (j = 0; j < N ; j++) begin
            idx = next_ptr + j;
             if (req[idx] && !found) begin
                 gnt[idx] = 1'b1;
                 found = 1'b1;
                 end
             else
                 gnt[idx] = 1'b0;
        end
        end
            endmodule

module rr_tb;

    reg clk;
    reg rst_n;
    reg [3:0] req;
    wire [3:0] granted;
    rr dut(
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .granted(granted)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        rst_n = 0;
        #10;

        rst_n = 1;
    #5  req = 4'b0000;
    #9 req = 4'b0001;
    #10 req = 4'b0010;
    #10 req = 4'b0101;
    #10 req = 4'b1110;
    #10 req = 4'b1111;
    #10 req = 4'b0100;
    #10 req = 4'b0001;
    #10 req = 4'b1101;
    #10 req = 4'b1001;
    #10 req = 4'b0101;

        #100;

        $finish;
    end
initial begin
    $fsdbDumpfile("./dump.fsdb");
    $fsdbDumpvars(0, rr_tb);
    $fsdbDumpMDA();
end

endmodule

