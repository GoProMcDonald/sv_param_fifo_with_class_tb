module fifo_ctrl #(
    parameter ADDR_WIDTH = 4
)(
    input  logic clk,
    input  logic rst,
    input  logic wr_en,
    input  logic rd_en,
    output logic [ADDR_WIDTH-1:0] wr_ptr,
    output logic [ADDR_WIDTH-1:0] rd_ptr,
    output logic full,
    output logic empty
);

    logic [ADDR_WIDTH:0] fifo_cnt;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            wr_ptr <= 0;
        else if (wr_en && !full)
            wr_ptr <= wr_ptr + 1;
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            rd_ptr <= 0;
        else if (rd_en && !empty)
            rd_ptr <= rd_ptr + 1;
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            fifo_cnt <= 0;
        else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: fifo_cnt <= fifo_cnt + 1;
                2'b01: fifo_cnt <= fifo_cnt - 1;
                default: fifo_cnt <= fifo_cnt;
            endcase
        end
    end

    assign full  = (fifo_cnt == (1 << ADDR_WIDTH));
    assign empty = (fifo_cnt == 0);

endmodule