class fifo_driver;

  virtual fifo_param_intf vif;
  int i;

  function new(virtual fifo_param_intf vif);//function定义了一个函数，这个函数的名字叫new，传入的参数是叫做vif，fifo param intf是vif的类型，而virtual表示这是一个虚拟接口
    this.vif = vif;
  endfunction

  task write_process();
    $display(">>> [WRITE_PROCESS] entered");
    for (i = 0; i < (1 << vif.ADDR_WIDTH); i++) begin//i < 16，表示你准备“尝试写 16 个数据进去
      @(negedge vif.clk);
      vif.wr_en <= $urandom_range(0, 1);//表示生成一个随机的 0 或 1，这一次是否写入，是随机决定的，有 50% 的概率写，有 50% 的概率不写
      vif.din   <= i;//不管 wr_en 是不是 1，din 都会被设置成当前这个值。但是只有 wr_en == 1 时，才会真的写进 FIFO。

      if (vif.wr_en && !vif.full)
        $display("[WRITE] Time: %0t  Data: %0d", $time, vif.din);
      
      @(negedge vif.clk);
      vif.wr_en <= 0;//确保 wr_en 的值在一个完整的时钟周期中保持稳定，给 DUT 足够时间进行采样！
    end
  endtask

endclass