#include <core.p4>
#include <v1model.p4>

register<bit<32>>(1) sketch_cnt_1;
register<bit<32>>(1) sketch_cnt_2;
register<bit<32>>(1) sketch_cnt_3;

header H {
    /* empty */
}

struct metadata {
    bit<32> is_hot_heavy_hitter;
}

struct headers {
    H   H_header;
}

const bit<32> LOW_TH =100;
const bit<32> HI_TH = 1000;

parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    state start {
        transition accept;
    }

}

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
    apply {
        @atomic{
            bit<32> sketch_cnt_1_tmp;
            bit<32> sketch_cnt_2_tmp;
            bit<32> sketch_cnt_3_tmp;
            sketch_cnt_1.read(sketch_cnt_1_tmp, 0);
            sketch_cnt_2.read(sketch_cnt_2_tmp, 0);
            sketch_cnt_3.read(sketch_cnt_3_tmp, 0);
            
            if (sketch_cnt_1_tmp > LOW_TH && sketch_cnt_1_tmp < HI_TH
                && sketch_cnt_2_tmp > LOW_TH && sketch_cnt_2_tmp < HI_TH
                && sketch_cnt_3_tmp > LOW_TH && sketch_cnt_3_tmp < HI_TH) {
                meta.is_hot_heavy_hitter = 0;
            } else {
                meta.is_hot_heavy_hitter = 1;
            }
            sketch_cnt_1_tmp = sketch_cnt_1_tmp + 1;
            sketch_cnt_2_tmp = sketch_cnt_2_tmp + 1;
            sketch_cnt_3_tmp = sketch_cnt_3_tmp + 1;

            sketch_cnt_1.write(0, sketch_cnt_1_tmp);
            sketch_cnt_2.write(0, sketch_cnt_2_tmp);
            sketch_cnt_3.write(0, sketch_cnt_3_tmp);

       }
    }
}

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply {  }
}

control MyComputeChecksum(inout headers  hdr, inout metadata meta) {
     apply {  }
}

control MyDeparser(packet_out packet, in headers hdr) {
    apply { }
}

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;
