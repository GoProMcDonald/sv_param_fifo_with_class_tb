`timescale 1ns/1ps

module tb_fifo;

  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 4;

  logic clk = 0;
  always #5 clk = ~clk;

  logic rst;

  // 创建 interface 实例（含参数）
  fifo_param_intf #(DATA_WIDTH, ADDR_WIDTH) intf();

  // DUT 实例化
  fifo_top #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) u_fifo_top (
    .clk    (intf.clk),//把 interface 中的 intf.clk 信号连接给 FIFO 模块的 clk 输入口
    .rst    (intf.rst),//把 interface 中的 intf.rst 连接给 FIFO 模块的复位输入口 rst
    .wr_en  (intf.wr_en),//把 interface 中的 intf.wr_en（写使能信号）连接给 FIFO 的 wr_en
    .rd_en  (intf.rd_en),
    .din    (intf.din),
    .dout   (intf.dout),
    .full   (intf.full),
    .empty  (intf.empty)
  );

  // 信号赋值连接（clk、rst 由 testbench 控制）
  assign intf.clk = clk;
  assign intf.rst = rst;

  // 驱动器和读取器
  fifo_driver  driver;//声明了一个 fifo_driver 类的对象，名叫 driver， class fifo_driver
  fifo_reader  reader;//声明了一个 fifo_reader 类的对象，名叫 reader， class fifo_reader

  initial begin
    $dumpfile("dump.vcd");          
    $dumpvars(0, tb_fifo);  // 仅指定 tb_fifo 范围，避免冗余作用域
    $dumpvars(0, u_fifo_top.u_core.mem);
    $dumpvars(0, u_fifo_top.u_core.wr_ptr_bin);
    $dumpvars(0, u_fifo_top.u_core.rd_ptr_bin);

    rst      = 1;
    intf.wr_en = 0;
    intf.rd_en = 0;
    intf.din   = 0;

    #20;
    rst = 0;

    driver = new(intf);
    reader = new(intf);

    fork//开始并行运行多个任务
      driver.write_process();
      reader.read_process();
    join//等所有并行任务结束才继续

    #100 $finish;
  end

endmodule
