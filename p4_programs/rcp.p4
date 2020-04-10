/*
Copyright 2019 RT-RK Computer Based Systems.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/


#include <core.p4>
#include <v1model.p4>


register<bit<32>>(1) input_traffic_bytes;
register<bit<32>>(1) sum_rtt_Tr;
register<bit<32>>(1) num_pkts_with_rtt;

const bit<32> MAX_ALLOWABLE_RTT = 30;

header H {
    bit<32> rtt;
}

struct metadata {
    /* empty */
    bit<32> pkt_len;
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
            bit<32> input_traffic_bytes_tmp;
            input_traffic_bytes.read(input_traffic_bytes_tmp, 0);
            input_traffic_bytes_tmp = input_traffic_bytes_tmp + meta.pkt_len;
            input_traffic_bytes.write(0, input_traffic_bytes_tmp);

            if (hdr.H_header.rtt < MAX_ALLOWABLE_RTT) {
                bit<32> sum_rtt_Tr_tmp;
                sum_rtt_Tr.read(sum_rtt_Tr_tmp, 1);
                sum_rtt_Tr_tmp = sum_rtt_Tr_tmp + hdr.H_header.rtt;
                sum_rtt_Tr.write(1, sum_rtt_Tr_tmp);

                bit<32> num_pkts_with_rtt_tmp;
                num_pkts_with_rtt.read(num_pkts_with_rtt_tmp, 2);
                num_pkts_with_rtt_tmp = num_pkts_with_rtt_tmp + 1;
                num_pkts_with_rtt.write(2, num_pkts_with_rtt_tmp);
            }
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
