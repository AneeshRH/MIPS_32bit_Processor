`timescale 1ns / 1ps


module cache_2way_sa (
    input         clock_sig,
    input  [31:0] mem_addr_in,       // byte address (same as data_memory_unit)
    input  [31:0] mem_write_data,
    input         ctrl_mem_rd,
    input         ctrl_mem_wr,
    output [31:0] mem_read_data,
    // Debug / probe outputs (kept identical to data_memory_unit)
    output [31:0] probe_mem_data,
    output [29:0] probe_word_addr
);


    parameter NUM_SETS  = 4;
    parameter NUM_WAYS  = 2;

    // -------------------------------------------------------------------------
    // Backing store: same 32-entry word-addressed DMEM as data_memory_unit
    // -------------------------------------------------------------------------
    integer iter_idx;
    reg [31:0] dmem_array [31:0];

    initial begin
        for (iter_idx = 0; iter_idx < 32; iter_idx = iter_idx + 1) begin
            if      (iter_idx == 9)  dmem_array[9]  = 32'd18;
            else if (iter_idx == 10) dmem_array[10] = 32'd118;
            else                     dmem_array[iter_idx] = 32'b0;
        end
    end

    // -------------------------------------------------------------------------
    // Cache arrays
    //   valid [NUM_SETS][NUM_WAYS]
    //   tag   [NUM_SETS][NUM_WAYS]  28-bit tag
    //   data  [NUM_SETS][NUM_WAYS]  32-bit word
    //   lru   [NUM_SETS]            1-bit: 0 = way-0 is LRU, 1 = way-1 is LRU
    // -------------------------------------------------------------------------
    reg        valid [0:NUM_SETS-1][0:NUM_WAYS-1];
    reg [27:0] tag   [0:NUM_SETS-1][0:NUM_WAYS-1];
    reg [31:0] data  [0:NUM_SETS-1][0:NUM_WAYS-1];
    reg        lru   [0:NUM_SETS-1];   // 0 → way-1 is MRU (evict way-0 next)
                                        // 1 → way-0 is MRU (evict way-1 next)

    integer s, w;
    initial begin
        for (s = 0; s < NUM_SETS; s = s + 1) begin
            lru[s] = 1'b0;
            for (w = 0; w < NUM_WAYS; w = w + 1) begin
                valid[s][w] = 1'b0;
                tag  [s][w] = 28'b0;
                data [s][w] = 32'b0;
            end
        end
    end

    // -------------------------------------------------------------------------
    // Address decode
    // -------------------------------------------------------------------------
    wire [29:0] word_addr  = mem_addr_in[31:2];   // 30-bit word address
    wire [1:0]  set_idx    = word_addr[1:0];       // bits [3:2] of byte addr
    wire [27:0] addr_tag   = word_addr[29:2];      // bits [31:4] of byte addr

    // -------------------------------------------------------------------------
    // Hit detection (combinational)
    // -------------------------------------------------------------------------
    wire hit0 = valid[set_idx][0] && (tag[set_idx][0] == addr_tag);
    wire hit1 = valid[set_idx][1] && (tag[set_idx][1] == addr_tag);
    wire cache_hit = hit0 | hit1;

    // Way that was hit (valid only when cache_hit)
    wire hit_way = hit1;   // 0 → way-0 hit, 1 → way-1 hit

    // Eviction target: way indicated by LRU bit
    wire evict_way = lru[set_idx];

    // -------------------------------------------------------------------------
    // Read data mux (combinational, for zero-latency hit reads)
    // -------------------------------------------------------------------------
    wire [31:0] cache_read_data = hit0 ? data[set_idx][0] :
                                  hit1 ? data[set_idx][1] :
                                         32'b0;

    // On a miss, fall through to backing store (1-cycle latency accepted)
    assign mem_read_data = ctrl_mem_rd ?
                               (cache_hit ? cache_read_data
                                          : dmem_array[word_addr[4:0]])
                               : 32'b0;

    // -------------------------------------------------------------------------
    // Sequential cache & memory update
    // -------------------------------------------------------------------------
    always @(posedge clock_sig) begin

        // ---- READ path -------------------------------------------------------
        if (ctrl_mem_rd) begin
            if (cache_hit) begin
                // Hit: just update LRU
                lru[set_idx] <= hit_way;   // MRU = hit way → other way is now LRU
            end else begin
                // Miss: fetch from backing store into evict_way (write-allocate)
                valid[set_idx][evict_way] <= 1'b1;
                tag  [set_idx][evict_way] <= addr_tag;
                data [set_idx][evict_way] <= dmem_array[word_addr[4:0]];
                lru  [set_idx]            <= ~evict_way; // newly filled way is MRU
            end
        end

        // ---- WRITE path (write-through + write-allocate) ---------------------
        if (ctrl_mem_wr) begin
            // Always write to backing store (write-through)
            dmem_array[word_addr[4:0]] <= mem_write_data;

            if (cache_hit) begin
                // Hit: update cache line too
                data[set_idx][hit_way] <= mem_write_data;
                lru [set_idx]          <= hit_way;
            end else begin
                // Miss: write-allocate → fill evict_way from written value
                valid[set_idx][evict_way] <= 1'b1;
                tag  [set_idx][evict_way] <= addr_tag;
                data [set_idx][evict_way] <= mem_write_data;
                lru  [set_idx]            <= ~evict_way;
            end
        end
    end

    // -------------------------------------------------------------------------
    // Debug / probe (identical signals to data_memory_unit)
    // -------------------------------------------------------------------------
    assign probe_mem_data = dmem_array[10];
    assign probe_word_addr = word_addr;

    // -------------------------------------------------------------------------
    // Optional: performance counter outputs (synthesis can tie off if unused)
    // -------------------------------------------------------------------------
    // Uncomment to expose hit/miss for testbench monitoring:
    // assign dbg_cache_hit  = cache_hit;
    // assign dbg_hit_way    = hit_way;

endmodule
