#include <core.p4>
#include <v1model.p4>


register<bit<32>>(1) last_update;
register<bit<32>>(1) p_mark;

header H {
    /* empty */
}

struct metadata {
    bit<32> now_plus_free;
    bit<32> now;
}

struct headers {
    H   H_header;
}

const bit<32> FREEZE_TIME = 10;
const bit<32> DELTA1 = 1;

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
            bit<32> last_update_tmp;
            bit<32> p_mark_tmp;
            last_update.read(last_update_tmp, 0);
            p_mark.read(p_mark_tmp, 1);
 
            meta.now_plus_free = meta.now - FREEZE_TIME;
            if (meta.now_plus_free > last_update_tmp) {
                p_mark_tmp = p_mark_tmp + DELTA1;
                last_update_tmp = meta.now;
            }
 
            last_update.write(0, last_update_tmp);
            p_mark.write(1, p_mark_tmp);
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
