#include <core.p4>
#include <v1model.p4>

register<bit<32>>(1) seen;
register<bit<32>>(1) last_ttl;
register<bit<32>>(1) ttl_change;


header H {
    /* empty */
}

struct metadata {
    bit<32> id;
    bit<32> rdata;
    bit<32> ttl;    
}

struct headers {
    H   H_header;
}

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
            bit<32> seen_tmp;
            bit<32> last_ttl_tmp;
            bit<32> ttl_change_tmp;
            seen.read(seen_tmp, 0);
            last_ttl.read(last_ttl_tmp, 0);
            ttl_change.read(ttl_change_tmp, 0);

            if (seen_tmp == 0) {
                seen_tmp = 1;
                last_ttl_tmp = meta.ttl;
                ttl_change_tmp = 0;
            } else {
               if (last_ttl_tmp != meta.ttl) {
                   last_ttl_tmp = meta.ttl;
                   ttl_change_tmp = ttl_change_tmp + 1;
               }
            } 

            seen.write(0, seen_tmp);
            last_ttl.write(0, last_ttl_tmp);
            ttl_change.write(0, ttl_change_tmp);
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
