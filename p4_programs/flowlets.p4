#include <core.p4>
#include <v1model.p4>

register<bit<32>>(1) last_time;
register<bit<32>>(1) saved_hop;

header H {
    /* empty */
}

struct metadata {
    bit<32> arrival;
    bit<32> new_hop;
    bit<32> next_hop;
}

struct headers {
    H   H_header;
}

const bit<32> THRESHOLD = 5;

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
            bit<32> last_time_tmp;
            bit<32> saved_hop_tmp;

            last_time.read(last_time_tmp, 0);
            saved_hop.read(saved_hop_tmp, 0);

            if (meta.arrival - last_time_tmp > THRESHOLD) {
                saved_hop_tmp = meta.new_hop;
            }
            last_time_tmp = meta.arrival;
            meta.next_hop = saved_hop_tmp;

            last_time.write(0, last_time_tmp);
            saved_hop.write(1, saved_hop_tmp);
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
