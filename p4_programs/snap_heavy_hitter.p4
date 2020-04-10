#include <core.p4>
#include <v1model.p4>


register<bit<32>>(1) heavy_hitter;
register<bit<32>>(1) hh_counter; 

header H {
    /* empty */
}

struct metadata {
    /* empty */
}

struct headers {
    H   H_header;
}

const bit<32> THRESHOLD = 1000;

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
            bit<32> heavy_hitter_tmp;
            bit<32> hh_counter_tmp;
            heavy_hitter.read(heavy_hitter_tmp, 0);
            hh_counter.read(hh_counter_tmp, 0);

            if (heavy_hitter_tmp == 0) {
                hh_counter_tmp = hh_counter_tmp + 1;
                if (hh_counter_tmp == THRESHOLD) {
                    heavy_hitter_tmp = 1;
                }
            }

            heavy_hitter.write(0, heavy_hitter_tmp);
            hh_counter.write(0, hh_counter_tmp);
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
